plugins {
    kotlin("jvm") version "1.9.20"
    id("com.google.cloud.tools.jib") version "3.4.0"
    application
}

group = "com.example"
version = "1.0.0"

application {
    mainClass.set("com.example.ApplicationKt")
}

repositories {
    mavenCentral()
}

dependencies {
    implementation("io.ktor:ktor-server-core-jvm:2.3.6")
    implementation("io.ktor:ktor-server-netty-jvm:2.3.6")
    implementation("io.ktor:ktor-server-content-negotiation-jvm:2.3.6")
    implementation("io.ktor:ktor-serialization-gson-jvm:2.3.6")
    implementation("ch.qos.logback:logback-classic:1.4.11")
    
    testImplementation("io.ktor:ktor-server-tests-jvm:2.3.6")
    testImplementation("org.jetbrains.kotlin:kotlin-test-junit:1.9.20")
}

jib {
    from {
        image = "eclipse-temurin:17-jre"
    }
    to {
        image = "gcr.io/estudapp-71947/ktor-sample"
        tags = setOf("latest")
    }
    container {
        ports = listOf("8080")
        environment = mapOf(
            "PORT" to "8080"
        )
        jvmFlags = listOf(
            "-server",
            "-Djava.awt.headless=true",
            "-XX:+UnlockExperimentalVMOptions",
            "-XX:+UseContainerSupport"
        )
    }
}