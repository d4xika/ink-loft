const SPOTIFY_CONTENT_TYPES = new Set([
  "album",
  "artist",
  "episode",
  "playlist",
  "show",
  "track",
]);

export function spotifyEmbedUrl(value) {
  if (!value) return null;

  try {
    const url = new URL(value);
    if (url.protocol !== "https:" || url.hostname !== "open.spotify.com") {
      return null;
    }

    const path = url.pathname.split("/").filter(Boolean);
    if (path[0]?.startsWith("intl-")) path.shift();
    if (path[0] === "embed") path.shift();

    const [type, id] = path;
    if (!SPOTIFY_CONTENT_TYPES.has(type) || !/^[a-zA-Z0-9]+$/.test(id)) {
      return null;
    }

    return `https://open.spotify.com/embed/${type}/${id}`;
  } catch {
    return null;
  }
}

export function externalSongUrl(value) {
  if (!value) return null;

  try {
    const url = new URL(value);
    return ["http:", "https:"].includes(url.protocol) ? url.href : null;
  } catch {
    return null;
  }
}
