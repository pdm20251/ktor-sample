package com.example

import io.ktor.server.application.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.http.*
import io.ktor.serialization.gson.*
import io.ktor.server.plugins.contentnegotiation.*

fun main() {
    embeddedServer(
        Netty,
        port = System.getenv("PORT")?.toInt() ?: 8080,
        host = "0.0.0.0",
        module = Application::module
    ).start(wait = true)
}

fun Application.module() {
    install(ContentNegotiation) {
        gson {
            setPrettyPrinting()
        }
    }
    
    routing {
        get("/") {
            call.respond(
                HttpStatusCode.OK,
                mapOf(
                    "message" to "Hello World from Ktor API!",
                    "timestamp" to System.currentTimeMillis(),
                    "version" to "1.0.0"
                )
            )
        }
        
        get("/health") {
            call.respond(
                HttpStatusCode.OK,
                mapOf("status" to "healthy")
            )
        }
    }
}