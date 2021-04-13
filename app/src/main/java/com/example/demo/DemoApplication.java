package com.example.demo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.repository.ReactiveMongoRepository;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;

@SpringBootApplication
public class DemoApplication {

    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }

    @Bean
    CommandLineRunner runner(PersonRepository repository) {
        return events -> {

            var writes = Flux
                    .just("Julien", "Kylie", "Asir", "Theresa", "Rory", "Josh")
                    .map(name -> new Person(null, name, 0))
                    .flatMap(repository::save);

            repository
                    .deleteAll()
                    .thenMany(writes)
                    .thenMany(repository.findAll())
                    .subscribe(System.out::println);

        };
    }

}

@Data
@AllArgsConstructor
@NoArgsConstructor
class Person {

    @Id
    private String id;
    private String name;
    private int age;
}

interface PersonRepository extends ReactiveMongoRepository<Person, String> {
}


@RestController
@RequiredArgsConstructor
class PeopleRestController {

    private final PersonRepository repository;

    @GetMapping("/people")
    Flux<Person> people() {
        return this.repository.findAll();
    }
}