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
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.ReactiveMongoRepository;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;

import java.util.Arrays;
import java.util.Collection;
import java.util.stream.Stream;

@SpringBootApplication
public class DemoApplication {

	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}

	@Bean
	CommandLineRunner runner(PersonRepository repository) {
		return events -> {
			repository.deleteAll();
			Stream.of("Julien", "Kylie", "Asir", "Theresa", "Rory", "Josh")
				.map(name -> new Person(null, name))
				.forEach(repository::save);
			repository.findAll().forEach(System.out::println);
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

}

interface PersonRepository extends MongoRepository<Person, String> {
}


@RestController
@RequiredArgsConstructor
class PeopleRestController {

	private final PersonRepository repository;

	@GetMapping("/people")
	Collection<Person> people() {
		return this.repository.findAll();
	}
}