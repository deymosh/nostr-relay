export const PORT = window.location.port;
// export const PORT = 3000;

// check if its a .onio domain
const isOnion = window.location.hostname.endsWith(".onion");
export const USE_TOR = isOnion;

// short version hostname for display (first part of domain****.onion)
export const READABLE_HOSTNAME = isOnion
  ? `${window.location.hostname.slice(0, 6)}****.onion`
  : window.location.hostname;

const PORT_ENDING = PORT ? `:${PORT}` : "";

export const WEB_SOCKET_RELAY_URL = `${
  window.location.protocol === "https:" ? "wss:" : "ws:"
}//${window.location.hostname}${PORT_ENDING}`;
export const READABLE_SOCKET_RELAY_URL = `${
  window.location.protocol === "https:" ? "wss:" : "ws:"
}//${READABLE_HOSTNAME}${PORT_ENDING}`;
export const HTTP_RELAY_URL = `${window.location.protocol}//${READABLE_HOSTNAME}${PORT_ENDING}`;
export const RELAY_PROXY_URL = `${window.location.protocol}//${READABLE_HOSTNAME}${PORT_ENDING}/relay-proxy`;
