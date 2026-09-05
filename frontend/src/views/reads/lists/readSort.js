const SORT_BY_VALUES = [
  "title",
  "author",
  "pairing",
  "date",
  "chapters",
  "pages",
  "words",
];
const SORT_DIRECTION_VALUES = ["asc", "desc"];

export function getSavedReadSort(listKey) {
  try {
    const savedSort = JSON.parse(
      localStorage.getItem(`read-list-sort:${listKey}`),
    );

    if (
      SORT_BY_VALUES.includes(savedSort?.sortBy) &&
      SORT_DIRECTION_VALUES.includes(savedSort?.sortDirection)
    ) {
      return savedSort;
    }
  } catch {}

  return { sortBy: "date", sortDirection: "desc" };
}

export function saveReadSort(listKey, sortBy, sortDirection) {
  localStorage.setItem(
    `read-list-sort:${listKey}`,
    JSON.stringify({ sortBy, sortDirection }),
  );
}
