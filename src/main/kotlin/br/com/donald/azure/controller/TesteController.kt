package br.com.donald.azure.controller

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/teste")


class TesteController {


    @GetMapping
    fun helloWorld(): String = "hello world"
}
