/// Sample reading content only. Books, statistics and trends now come from
/// Firestore (see BookRepository / SessionRepository) — this class no
/// longer holds any book data.
///
/// The Speed Reader doesn't yet ingest real book text (no PDF/EPUB import),
/// so every book is read against this same sample paragraph until that
/// feature exists.
class MockData {
  MockData._();

  static const sampleParagraph =
      'Every action you take is a vote for the person you wish to become. '
      'Success is the product of daily habits, not once-in-a-lifetime transformations. '
      'You do not rise to the level of your goals, you fall to the level of your systems. '
      'The most practical way to change who you are is to change what you do. '
      'Small habits do not add up, they compound. '
      'Time magnifies the margin between success and failure. '
      'It will multiply whatever you feed it. '
      'Good habits make time your ally, bad habits make time your enemy.';
}
