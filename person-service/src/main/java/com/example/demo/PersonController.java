package com.example.demo;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;

@RestController
public class PersonController {

    private static final Log log = LogFactory.getLog(PersonController.class);

    private final PersonRepository personRepository;

    public PersonController(PersonRepository personRepository) {
        this.personRepository = personRepository;
        Person julien = new Person("Julien", 44);
        personRepository.save(julien).block();
        log.info(julien.getId());
    }

    @GetMapping("/")
    Flux<Person> persons() {
        return personRepository.findAll();
    }
}
