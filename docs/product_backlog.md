# Product Backlog - Features Dump

Historia de Usuario 1: Registro de equipos

Epic: Gestión de ligas de fútbol

Historia de Usuario 1: Registro de equipos

**Como** organizador de la liga,
**Quiero** registrar equipos con su nombre y entrenador,
**Para que** puedan participar en el torneo.

Criterios de aceptación (Gherkin)

```gherkin
Scenario: Registrar un equipo

Given que el organizador está en la sección "Equipos"
When captura el nombre del equipo y el entrenador y presiona "Guardar"
Then el sistema registra el equipo correctamente
And el equipo aparece en la lista de participantes

Scenario: Ver tabla de posiciones

Given que existen partidos registrados
When el usuario entra a la sección "Tabla de posiciones"
Then el sistema muestra los equipos ordenados por puntos
And muestra partidos jugados, goles y diferencia de goles
```

Historia de Usuario 2: Consulta de la tabla de posiciones

**Como** aficionado de la liga,
**Quiero** consultar la tabla de posiciones,
**Para que pueda** conocer la clasificación actual de los equipos.
Criterios de aceptación (Gherkin)

```gherkin

Scenario: Ver tabla de posiciones

Given que existen partidos registrados
When el usuario entra a la sección "Tabla de posiciones"
Then el sistema muestra los equipos ordenados por puntos
And muestra partidos jugados, goles y diferencia de goles
```

Historia de Usuario 3: Registro de resultados

**Como** árbitro de la liga,
**Quiero** registrar el resultado de un partido,
**Para que** la tabla de posiciones se actualice automáticamente.

Criterios de aceptación (Gherkin)

```gherkin

Scenario: Registrar resultado de un partido

Given que el partido está programado
When el árbitro captura el marcador final y guarda los datos
Then el resultado queda registrado
And la tabla de posiciones se actualiza automáticamente



