<<<<<<< HEAD
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

=======
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

<<<<<<< HEAD
// 🔧 Força todos os subprojetos (inclusive plugins) a compilarem com JVM 17
subprojects {
    // aplica a configuração de toolchain para todos os módulos Kotlin
    plugins.withId("org.jetbrains.kotlin.android") {
        extensions.configure<org.jetbrains.kotlin.gradle.dsl.KotlinAndroidProjectExtension>("kotlin") {
            jvmToolchain(17)
        }
    }

    // garante o mesmo nível para código Java
    tasks.withType<JavaCompile>().configureEach {
        // ✅ Corrigido: o Kotlin DSL espera strings, não enum JavaVersion
=======
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

// 🧹 Tarefa de limpeza
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// 🔧 >>> NOVO BLOCO – força todos os módulos a usarem mesma JVM (21)
subprojects {
    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
        kotlinOptions {
            jvmTarget = "17"
        }
    }
    tasks.withType<JavaCompile>().configureEach {
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
        sourceCompatibility = "17"
        targetCompatibility = "17"
    }
}
<<<<<<< HEAD

// 🧹 Tarefa global de limpeza
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
=======
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
