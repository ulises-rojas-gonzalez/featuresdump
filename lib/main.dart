import 'models.dart';

/// Repositorio principal alineado con el backlog 'Features Dump'
class FeaturesDumpRepository {
  final List<Team> _teams = [];
  final List<Match> _matches = [];
  final List<Standing> _standings = [];

  List<Team> get teams => _teams;
  List<Match> get matches => _matches;

  // --- US-1: REGISTER TEAMS ---
  bool registerTeam(String name, String coach) {
    bool exists = _teams.any((t) => t.teamName.toLowerCase() == name.trim().toLowerCase());
    if (exists || name.trim().isEmpty) {
      return false; 
    }

    final newTeam = Team(
      teamId: _teams.length + 1,
      teamName: name.trim(),
      coachName: coach.trim(),
    );

    _teams.add(newTeam);
    _standings.add(Standing(teamId: newTeam.teamId)); 
    return true; 
  }

  // --- US-3: REGISTER MATCH RESULTS ---
  bool registerMatchResult(int matchId, int homeScore, int awayScore) {
    if (homeScore < 0 || awayScore < 0) return false;

    final matchIndex = _matches.indexWhere((m) => m.matchId == matchId);
    if (matchIndex == -1) return false;

    _matches[matchIndex].homeScore = homeScore;
    _matches[matchIndex].awayScore = awayScore;
    _matches[matchIndex].status = "FINISHED";

    _recalculateStandings();
    return true;
  }

  // --- US-2: VIEW LEAGUE STANDINGS ---
  void _recalculateStandings() {
    for (var standing in _standings) {
      standing.played = 0;
      standing.won = 0;
      standing.drawn = 0;
      standing.lost = 0;
      standing.goalsFor = 0;
      standing.goalsAgainst = 0;
    }

    for (var match in _matches.where((m) => m.status == "FINISHED")) {
      final home = _standings.firstWhere((s) => s.teamId == match.homeTeamId);
      final away = _standings.firstWhere((s) => s.teamId == match.awayTeamId);

      home.played++;
      away.played++;
      home.goalsFor += match.homeScore;
      home.goalsAgainst += match.awayScore;
      away.goalsFor += match.awayScore;
      away.goalsAgainst += match.homeScore;

      if (match.homeScore > match.awayScore) {
        home.won++;
        away.lost++;
      } else if (match.awayScore > match.homeScore) {
        away.won++;
        home.lost++;
      } else {
        home.drawn++;
        away.drawn++;
      }
    }
  }

  List<Standing> getLeagueStandings() {
    List<Standing> sortedList = List.from(_standings);
    sortedList.sort((a, b) {
      int cmp = b.points.compareTo(a.points);
      if (cmp != 0) return cmp;
      return b.goalDifference.compareTo(a.goalDifference); 
    });
    return sortedList;
  }

  void createMatchFixture(int homeTeamId, int awayTeamId) {
    _matches.add(Match(
      matchId: _matches.length + 1,
      homeTeamId: homeTeamId,
      awayTeamId: awayTeamId,
    ));
  }
}