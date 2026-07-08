// models.dart

/// Entidad que representa a un equipo (US-1)
class Team {
  final int teamId;
  final String teamName;
  final String coachName;

  Team({
    required this.teamId,
    required this.teamName,
    required this.coachName,
  });
}

/// Entidad que representa un partido programado o jugado (US-3)
class Match {
  final int matchId;
  final int homeTeamId;
  final int awayTeamId;
  int homeScore;
  int awayScore;
  String status; // "PENDING" o "FINISHED"

  Match({
    required this.matchId,
    required this.homeTeamId,
    required this.awayTeamId,
    this.homeScore = 0,
    this.awayScore = 0,
    this.status = "PENDING",
  });
}

/// Entidad que gestiona las estadísticas de la tabla de posiciones (US-2)
class Standing {
  final int teamId;
  int played;
  int won;
  int drawn;
  int lost;
  int goalsFor;
  int goalsAgainst;

  Standing({
    required this.teamId,
    this.played = 0,
    this.won = 0,
    this.drawn = 0,
    this.lost = 0,
    this.goalsFor = 0,
    this.goalsAgainst = 0,
  });

  // Tarea US-2: Calcular automáticamente la diferencia de goles y los puntos
  int get goalDifference => goalsFor - goalsAgainst;
  int get points => (won * 3) + (drawn * 1);
}
// features_dump_repository.dart
import 'models.dart';

/// Repositorio oficial alineado estrictamente con el backlog 'Features Dump'.
/// Controla el estado en memoria y las reglas de negocio del torneo.
class FeaturesDumpRepository {
  final List<Team> _teams = [];
  final List<Match> _matches = [];
  final List<Standing> _standings = [];

  // Getters para exponer los datos a la interfaz de usuario (UI)
  List<Team> get teams => _teams;
  List<Match> get matches => _matches;

  FeaturesDumpRepository();

  // ==========================================================
  // --- US-1: REGISTER TEAMS (Gestión de ligas de fútbol) ---
  // ==========================================================

  /// Registra un equipo validando que los campos no estén vacíos 
  /// y que el nombre no esté duplicado (Tarea: Validate duplicate team names).
  bool registerTeam(String name, String coach) {
    final cleanedName = name.trim();
    final cleanedCoach = coach.trim();

    if (cleanedName.isEmpty || cleanedCoach.isEmpty) {
      return false; // Error: campos vacíos
    }

    // Validación de duplicados (Ignora mayúsculas/minúsculas)
    bool isDuplicate = _teams.any(
      (t) => t.teamName.toLowerCase() == cleanedName.toLowerCase()
    );
    
    if (isDuplicate) {
      return false; // Error: Nombre duplicado
    }

    // Crear y guardar el nuevo equipo con ID autoincremental
    final newTeam = Team(
      teamId: _teams.length + 1,
      teamName: cleanedName,
      coachName: cleanedCoach,
    );
    _teams.add(newTeam);
    
    // Inicializar fila vacía en la tabla de posiciones para este equipo
    _standings.add(Standing(teamId: newTeam.teamId)); 
    
    return true; 
  }

  // ==========================================================
  // --- US-3: REGISTER MATCH RESULTS (Rol: Árbitro)        ---
  // ==========================================================

  /// Registra el marcador de un partido y actualiza la tabla automáticamente.
  bool registerMatchResult(int matchId, int homeScore, int awayScore) {
    // Tarea: Validate the entered scores (no se permiten goles negativos)
    if (homeScore < 0 || awayScore < 0) {
      return false;
    }

    // Buscar el partido programado
    final matchIndex = _matches.indexWhere((m) => m.matchId == matchId);
    if (matchIndex == -1) {
      return false; // El partido no existe
    }

    // Asignar el marcador final y finalizar el estado del partido
    _matches[matchIndex].homeScore = homeScore;
    _matches[matchIndex].awayScore = awayScore;
    _matches[matchIndex].status = "FINISHED";

    // Tarea: Update the standings automatically
    _recalculateStandings();
    return true;
  }

  // ==========================================================
  // --- US-2: VIEW LEAGUE STANDINGS (Rol: Aficionado)      ---
  // ==========================================================

  /// Algoritmo interno automatizado para computar las estadísticas de la tabla de posiciones.
  void _recalculateStandings() {
    // Reiniciar contadores a cero antes de volver a computar
    for (var standing in _standings) {
      standing.played = 0;
      standing.won = 0;
      standing.drawn = 0;
      standing.lost = 0;
      standing.goalsFor = 0;
      standing.goalsAgainst = 0;
    }

    // Procesar todos los partidos que el árbitro ya dio por terminados
    for (var match in _matches.where((m) => m.status == "FINISHED")) {
      final home = _standings.firstWhere((s) => s.teamId == match.homeTeamId);
      final away = _standings.firstWhere((s) => s.teamId == match.awayTeamId);

      home.played++;
      away.played++;
      home.goalsFor += match.homeScore;
      home.goalsAgainst += match.awayScore;
      away.goalsFor += match.awayScore;
      away.goalsAgainst += match.homeScore;

      // Determinar ganador, perdedor o empate
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

  /// Tarea: Display teams ordered by points.
  /// Obtiene la tabla ordenada de mayor a menor puntuación.
  List<Standing> getLeagueStandings() {
    List<Standing> sortedList = List.from(_standings);
    
    sortedList.sort((a, b) {
      int pointsComparison = b.points.compareTo(a.points);
      if (pointsComparison != 0) return pointsComparison;
      
      // Criterio de desempate por diferencia de goles
      return b.goalDifference.compareTo(a.goalDifference); 
    });
    
    return sortedList;
  }

  // ==========================================================
  // --- CONTROL DE DEPENDENCIAS Y UTILERÍAS                 ---
  // ==========================================================

  /// Permite agendar un partido entre dos equipos que ya estén registrados.
  /// Cumple la regla: "Teams must be registered before scheduling matches".
  bool scheduleMatch(int homeTeamId, int awayTeamId) {
    bool homeExists = _teams.any((t) => t.teamId == homeTeamId);
    bool awayExists = _teams.any((t) => t.teamId == awayTeamId);

    if (!homeExists || !awayExists || homeTeamId == awayTeamId) {
      return false; // Los equipos no existen o es el mismo equipo
    }

    _matches.add(Match(
      matchId: _matches.length + 1,
      homeTeamId: homeTeamId,
      awayTeamId: awayTeamId,
    ));
    return true;
  }

  /// Devuelve el nombre de un equipo buscando por su ID único.
  String getTeamNameById(int id) {
    return _teams.firstWhere(
      (t) => t.teamId == id, 
      orElse: () => Team(teamId: 0, teamName: 'No registrado', coachName: '')
    ).teamName;
  }
}
// main.dart
import 'features_dump_repository.dart';

void main() {
  final repository = FeaturesDumpRepository();

  print('=== INICIANDO PRUEBAS UNITARIAS: SPRINT 1 ===\n');

  // --------------------------------------------------
  // PRUEBA US-1: REGISTRO DE EQUIPOS
  // --------------------------------------------------
  print('-> Probando US-1: Registro de Equipos...');
  
  // Registrar equipos válidos
  bool reg1 = repository.registerTeam('Alfa FC', 'Director 1');
  bool reg2 = repository.registerTeam('Beta FC', 'Director 2');
  print('   Registro de equipos nuevos: ${reg1 && reg2 ? "PASÓ ✅" : "FALLÓ ❌"}');

  // Validar duplicados (Debe dar false)
  bool regDuplicate = repository.registerTeam('Alfa FC', 'Otro Director');
  print('   Validación de nombres duplicados: ${!regDuplicate ? "PASÓ ✅" : "FALLÓ ❌"}');
  print('   Total de equipos registrados: ${repository.teams.length} (Esperado: 2)\n');

  // --------------------------------------------------
  // CONTROL DE DEPENDENCIAS: PROGRAMACIÓN DE PARTIDOS
  // --------------------------------------------------
  print('-> Creando calendario de partidos...');
  // Programamos Alfa FC (ID: 1) vs Beta FC (ID: 2)
  bool matchScheduled = repository.scheduleMatch(1, 2);
  print('   Partido programado con éxito: ${matchScheduled ? "PASÓ ✅" : "FALLÓ ❌"}\n');

  // --------------------------------------------------
  // PRUEBA US-3: REGISTRO DE RESULTADOS (ÁRBITRO)
  // --------------------------------------------------
  print('-> Probando US-3: Registro de Resultados...');
  
  // Validar marcador inválido (negativo)
  bool invalidResult = repository.registerMatchResult(1, -1, 2);
  print('   Validación de marcadores negativos: ${!invalidResult ? "PASÓ ✅" : "FALLÓ ❌"}');

  // Registrar resultado válido: Alfa FC 2 - 0 Beta FC
  bool validResult = repository.registerMatchResult(1, 2, 0);
  print('   Registro de marcador correcto (2-0): ${validResult ? "PASÓ ✅" : "FALLÓ ❌"}\n');

  // --------------------------------------------------
  // PRUEBA US-2: TABLA DE POSICIONES (AFICIONADO)
  // --------------------------------------------------
  print('-> Probando US-2: Tabla de Posiciones...');
  var standings = repository.getLeagueStandings();

  if (standings.isNotEmpty) {
    final primerLugar = standings.first;
    final nombrePrimerLugar = repository.getTeamNameById(primerLugar.teamId);
    
    print('   Primer lugar en la tabla: $nombrePrimerLugar');
    print('   Puntos del primer lugar: ${primerLugar.points} (Esperado: 3)');
    print('   Diferencia de goles: ${primerLugar.goalDifference} (Esperado: 2)');
    
    if (primerLugar.teamId == 1 && primerLugar.points == 3 && primerLugar.goalDifference == 2) {
      print('   Cálculo y ordenamiento automático de la tabla: PASÓ ✅\n');
    } else {
      print('   Cálculo y ordenamiento automático de la tabla: FALLÓ ❌\n');
    }
  }

  print('=== FIN DE LAS PRUEBAS: TODO COMPILA Y SE EJECUTA SEGÚN EL DOD ===');
}