// Nostr event kinds
export const NOSTR_KINDS = {
  METADATA: 0,
  TEXT_NOTE: 1,
  RECOMMEND_RELAY: 2,
  FOLLOWS: 3,
  ENCRYPTED_DIRECT_MESSAGE: 4,
  DELETED: 5,
  REPOST: 6,
  REACTION: 7,
  BADGE_AWARD: 8,
  CHAT_MESSAGE: 9,
  THREAD: 11,
  DIRECT_MESSAGE: 14,
  FILE_MESSAGE: 15,
  PICTURE: 20,
  VIDEO: 21,
  SHORT_PORTRAIT_VIDEO: 22,
  CHANNEL_CREATE: 40,
  CHANNEL_METADATA: 41,
  CHANNEL_MESSAGE: 42,
  CHANNEL_HIDE_MESSAGE: 43,
  CHANNEL_MUTE_USER: 44,
  GIFT_WRAP: 1059,
  REPORT: 1984,
  LABEL: 1985,
  ZAP_REQUEST: 9734,
  ZAP: 9735,
};

// supported Nostr event kinds with icons and names
export const supportedEventKinds = {
  [NOSTR_KINDS.METADATA]: {
    icon: "📝",
    name: "Profile Update",
  },
  [NOSTR_KINDS.TEXT_NOTE]: {
    icon: "💭",
    name: "Post",
    showContent: true,
  },
  [NOSTR_KINDS.RECOMMEND_RELAY]: {
    icon: "📶",
    name: "Relay Update",
  },
  [NOSTR_KINDS.FOLLOWS]: {
    icon: "🤝",
    name: "Following Update",
  },
  [NOSTR_KINDS.ENCRYPTED_DIRECT_MESSAGE]: {
    icon: "🔏",
    name: "Encrypted DM",
  },
  [NOSTR_KINDS.DELETED]: {
    icon: "🗑",
    name: "Deleted Action",
  },
  [NOSTR_KINDS.REPOST]: {
    icon: "🔁",
    name: "Repost",
  },
  [NOSTR_KINDS.REACTION]: {
    icon: "🤙",
    name: "Reaction",
  },
  [NOSTR_KINDS.BADGE_AWARD]: {
    icon: "🏆",
    name: "Badge Award",
  },
  [NOSTR_KINDS.CHAT_MESSAGE]: {
    icon: "💬",
    name: "Chat Message",
  },
  [NOSTR_KINDS.THREAD]: {
    icon: "💬",
    name: "Thread response",
  },
  [NOSTR_KINDS.DIRECT_MESSAGE]: {
    icon: "📨",
    name: "Direct Message",
  },
  [NOSTR_KINDS.FILE_MESSAGE]: {
    icon: "📨",
    name: "File Message",
  },
  [NOSTR_KINDS.PICTURE]: {
    icon: "📷",
    name: "Picture",
  },
  [NOSTR_KINDS.VIDEO]: {
    icon: "📷",
    name: "Video",
  },
  [NOSTR_KINDS.CHANNEL_CREATE]: {
    icon: "🧙‍♂️",
    name: "Channel Creation",
  },
  [NOSTR_KINDS.CHANNEL_METADATA]: {
    icon: "🪄",
    name: "Channel Update",
  },
  [NOSTR_KINDS.CHANNEL_MESSAGE]: {
    icon: "📢",
    name: "Channel Message",
    showContent: true,
  },
  [NOSTR_KINDS.CHANNEL_HIDE_MESSAGE]: {
    icon: "🙈",
    name: "Hid Message",
  },
  [NOSTR_KINDS.CHANNEL_MUTE_USER]: {
    icon: "🙊",
    name: "Muted User",
  },
  [NOSTR_KINDS.GIFT_WRAP]: {
    icon: "🎁",
    name: "Gift Wrap",
  },
  [NOSTR_KINDS.REPORT]: {
    icon: "🚩",
    name: "Report",
  },
  [NOSTR_KINDS.ZAP_REQUEST]: {
    icon: "⚡",
    name: "Zap Request",
  },
  [NOSTR_KINDS.ZAP]: {
    icon: "⚡",
    name: "Zap",
  },
};
