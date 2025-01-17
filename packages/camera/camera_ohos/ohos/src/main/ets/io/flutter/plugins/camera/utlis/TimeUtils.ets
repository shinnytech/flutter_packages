const TEN = 10; // 这是数字10
const SIXTY = 60; // 时间进制
const THOUSAND = 1000; // 这是数字1000

export function tempNum(num: number): string {
  if (num < TEN) {
    return '0' + num;
  }
  return num.toString();
}

export function getDurationString(duration: number): string {
  let hour = Math.floor(duration / (THOUSAND * SIXTY * SIXTY));
  let minute = Math.floor((duration - hour * (THOUSAND * SIXTY * SIXTY)) / (THOUSAND * SIXTY));
  let second = Math.floor(
    (duration - hour * (THOUSAND * SIXTY * SIXTY) - minute * (SIXTY * THOUSAND)) / THOUSAND
  );
  if (hour > 0) {
    return `${tempNum(hour)}:${tempNum(minute)}:${tempNum(second)}`;
  }
  return `${tempNum(minute)}:${tempNum(second)}`;
}
