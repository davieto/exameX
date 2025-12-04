
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile


allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

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

        sourceCompatibility = "17"
        targetCompatibility = "17"
    }
}

// 🧹 Tarefa global de limpeza
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

