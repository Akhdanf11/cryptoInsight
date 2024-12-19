String formatDuration(Duration duration) {
  return "${duration.inMinutes}:${duration.inSeconds % 60}";
}
