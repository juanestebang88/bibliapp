import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bibliapp/core/error/failure.dart';
import 'package:bibliapp/core/localization/app_strings.dart';
import 'package:bibliapp/features/reading/domain/entities/verse_entity.dart';
import 'package:bibliapp/features/reading/domain/usecases/search_verses.dart';
import 'package:bibliapp/features/reading/presentation/cubit/search_cubit.dart';

void main() {
  late _MockSearchVerses searchVerses;
  late SearchCubit cubit;

  setUp(() {
    searchVerses = _MockSearchVerses();
    cubit = SearchCubit(searchVerses: searchVerses);
  });

  test('searches and emits success with matched words', () async {
    when(() => searchVerses.call('amor')).thenAnswer(
      (_) async => const Right<Failure, List<VerseEntity>>([
        VerseEntity(book: 'genesis', chapter: 1, verse: 1, text: 'Amor real'),
      ]),
    );

    final states = <SearchState>[];
    final subscription = cubit.stream.listen(states.add);

    await cubit.search(' amor ');
    await Future<void>.delayed(Duration.zero);

    expect(states.map((s) => s.status), [
      SearchStatus.loading,
      SearchStatus.success,
    ]);
    final result = states.last.results.single;
    expect(result.verse.text, 'Amor real');
    expect(result.matchedWords, ['amor']);
    expect(cubit.state.query, 'amor');

    await subscription.cancel();
  });

  test('rejects an empty query', () async {
    final states = <SearchState>[];
    final subscription = cubit.stream.listen(states.add);

    await cubit.search('   ');
    await Future<void>.delayed(Duration.zero);

    expect(states.map((s) => s.status), [
      SearchStatus.loading,
      SearchStatus.failure,
    ]);
    expect(cubit.state.errorMessage, AppStrings.emptyQuery);

    await subscription.cancel();
  });

  test('surfaces a datasource failure', () async {
    when(() => searchVerses.call('amor')).thenAnswer(
      (_) async =>
          const Left<Failure, List<VerseEntity>>(DatabaseFailure('db down')),
    );

    final states = <SearchState>[];
    final subscription = cubit.stream.listen(states.add);

    await cubit.search('amor');
    await Future<void>.delayed(Duration.zero);

    expect(states.map((s) => s.status), [
      SearchStatus.loading,
      SearchStatus.failure,
    ]);
    expect(cubit.state.errorMessage, contains('db down'));

    await subscription.cancel();
  });
}

class _MockSearchVerses extends Mock implements SearchVerses {}
