# scfx (project)

Legacy Java/Maven app at `/mnt/external/projects/scfx` (i.e. `~/projects/scfx`).
This is **project context**, not part of the base OS setup — include only if
rebuilding to work on scfx.

## Build recipe (verified 2026-06-25)
- **Reactor root:** `~/projects/scfx/scfx-all` (NOT the repo root). 12 modules;
  final artifact `scfx-web` (WAR).
- **JDK 8 required:** `~/.sdkman/candidates/java/8.0.452-tem`. The default JDK 21
  breaks the AspectJ 1.8.9 / Spring Roo 1.2.5 / Spring 4.3.2 stack. Set
  `JAVA_HOME` to JDK 8 for the build (`sdk use` doesn't persist across separate
  tool calls). Maven **3.3.9** (SDKMAN).
- **Compile-only WAR** (frontend + tests skipped):
  ```bash
  JAVA_HOME=~/.sdkman/candidates/java/8.0.452-tem \
  mvn -B clean install -Dskip.installnodenpm=true -Dskip.npm=true -Dskip.webpack=true -DskipTests
  ```
  (frontend-maven-plugin 1.11.0; the three `skip.*` props skip the node download,
  the private-npm-registry login, and webpack.)

## Dead-repo / orphaned artifacts (machine-local — NOT backed up)
`maven.springframework.org` and `spring-roo-repository.springsource.org` are gone
and `repo.spring.io` is paywalled. Most deps fall back to Maven Central, but five
artifacts were **hand-installed into `~/.m2`** (no pom edits). On a new machine
these must be re-installed (they exist nowhere else automatically):
- `org.springframework.roo:org.springframework.roo.annotations:1.2.5.RELEASE`
  — real jar from `maven.aliyun.com/repository/public`.
- `com.lowagie:itext:2.1.7.js6` and `org.olap4j:olap4j:0.9.7.309-JS-3` — real
  JasperReports custom builds from `jaspersoft.jfrog.io/.../third-party-ce-artifacts`.
- `org.primefaces:primefaces:3.5` — **STUB** (only json/model/event classes from
  PF 4.0; no UI framework — PF 3.5 community is unavailable publicly).
- `org.primefaces.themes:{south-street:1.0.10, humanity:1.0.8, start:1.0.10}` —
  **empty stub jars** (themes are CSS/images; not on any public repo).
All installed with `maven-install-plugin:2.4:install-file ... -DgeneratePom=true`.

**Caveat:** with the primefaces/theme stubs the build **compiles and packages**
(`scfx-web/target/scfx-web.war`, ~296MB) but the deployed PrimeFaces UI (35 xhtml
pages) will **not render**. For a runnable build you need the genuine
`primefaces-3.5.jar` + real theme jars (from the original internal Nexus or a
prior deploy). Only 16 Java files use PrimeFaces, all via the stable
json/model/event API.

## Related initiatives / docs
- **App-store sales connector** (`[[project-scfx-appstore-connector]]`): an
  agent-facing interface to upload app store sales data into scfx — in progress.
  Prefer agent-friendly designs (clean API, structured input, clear errors).
- **Remediation doc TODO** (`[[todo-scfx-remediation-doc]]`): a team-facing
  write-up of permanently removing the 5 orphaned artifacts currently sits at
  `~/scfx-orphan-artifacts-remediation.md` — should be committed into
  `scfx/docs/`.
