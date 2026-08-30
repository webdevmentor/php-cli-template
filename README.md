# PHP CLI Template

Ein modernes, leichtgewichtiges Template für PHP CLI-Anwendungen mit Docker, Docker Compose, Mailpit und PHPUnit.

Ein integriertes CLI-Beispielskript steht unter `bin/example` bereit. Nach dem Verbinden mit dem Container via `make shell` kann das Skript mit `bin/example` ausgeführt werden – alle weiteren Funktionen und Optionen lassen sich mit `bin/example --help` anzeigen.

---

## 🚀 Features

- **PHP 8.5 CLI** Basis-Image inklusive `mbstring` und Composer
- **Docker Compose** Setup für reproduzierbare Entwicklungsumgebungen
- **Mailpit** integriert zum lokalen Testen und Abfangen von E-Mails (Web-UI auf `http://localhost:8025`)
- **PHPUnit 12** für automatisierte Unit- und Integrationstests
- **Makefile** zur einfachen Steuerung aller Entwicklungsbefehle
- **CI Workflow** mit GitHub Actions für automatische Tests bei Pushes und Merges

---

## 📋 Voraussetzungen

- [Docker](https://www.docker.com/) & Docker Compose
- `make`

---

## 🛠️ Run locally

Der folgende Ablauf kann zur lokalen Einrichtung und Ausführung des Projekts verwendet werden:

### 1. Umgebung initialisieren

Erstellt die `.env`-Datei, baut die Docker-Images und installiert die Composer-Abhängigkeiten:

```bash
make install
```

### 2. Tägliche Commands

Startet die Container im Hintergrund und öffnet direkt eine interaktive Shell im PHP-Container:

```bash
make shell
```

Stoppt alle laufenden Container (z. B. beim Projektwechsel, um Ressourcen freizugeben):

```bash
make stop
```

### 3. Nützliche Makefile-Befehle

Eine Übersicht aller verfügbaren Befehle und deren Beschreibung erhältst du mit:

```bash
make help
```

### 4. Mailpit Web-UI

Mailpit fängt ausgehende E-Mails lokal ab. Die Weboberfläche ist standardmäßig erreichbar unter:

👉 [http://localhost:8025](http://localhost:8025)

---

## 📁 Projektstruktur

```text
├── bin/                    # Ausführbare CLI-Skripte / Einstiegspunkte
├── src/                    # Anwendungsquellcode (Namespace: App\)
├── tests/                  # Testsuite (Namespace: Tests\)
│   ├── Integration/        # Integrationstests
│   └── Unit/               # Unit-Tests
├── compose.yaml            # Docker Compose Konfiguration
├── Dockerfile              # PHP CLI Docker-Definition
├── Makefile                # Komfort-Befehle für Entwicklung & Tests
└── phpunit.xml             # PHPUnit-Konfiguration
```

---

## 👤 Urheber

Dieses Template wurde erstellt und bereitgestellt von [WebDevMentor](https://github.com/webdevmentor).

Weitere Informationen, Ressourcen und Updates findest du bei [WebDevMentor](https://www.webdevmentor.info).

---

## 📄 Lizenz

Dieses Projekt steht unter der [MIT-Lizenz](LICENSE).
