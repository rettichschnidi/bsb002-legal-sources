set -o pipefail

log() {
	local level=${1};shift
	logger -p daemon.${level} -t ntpd "$*"
}

notify_time_synched() {
	local method=${1}
	local last_update=`date +"%Y-%m-%dT%H:%M:%SZ"`
	local event="${method}@${last_update}"
	mkdir -p `dirname ${SYNC_NOTIFICATION_FILE}`
	echo -n "${event}" >${SYNC_NOTIFICATION_FILE}
	log notice "time synched with ${event}"
}

sync_from_tls_server() {
	local source=${1};shift
	local options=${*}
	log notice "tlsdate: sync ${source}${options:+ using ${options}}"
	tlsdate -H ${source} ${options} || return 1
	notify_time_synched tlsdate
	return 0
}

sync_with_tls() {
	local servers="`uci get system.tlsdate.server`"
	[ -n "${servers}" ] || return 0

	local options="`uci get system.tlsdate.options`"
	
	local server
	for server in ${servers}; do
		sync_from_tls_server ${server} ${options} && return 0
		log warning "tlsdate failed synching from ${server}"
	done
}

is_time_synched() {
	[ -f "${SYNC_NOTIFICATION_FILE}" ]
}

