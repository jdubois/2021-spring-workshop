package com.example.people;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Component;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Collection;
import java.util.stream.Stream;

@SpringBootApplication
public class PeopleApplication {

	public static void main(String[] args) {
		SpringApplication.run(PeopleApplication.class, args);
	}

}

@RestController
@RequiredArgsConstructor
class PeopleRestController {

	private final PersonRepository repository;

	@GetMapping("/people")
	Collection<Person> get() {
		return this.repository.findAll();
	}

}

@Component
class Initializer implements CommandLineRunner {

	private final PersonRepository repository;

	Initializer(PersonRepository repository, @Value("${application.message}") String message) {
		this.repository = repository;
		System.out.println("the message is " + message);
	}

	@Override
	public void run(String... args) throws Exception {

		this.repository.deleteAll();

		Stream.of(
			"Julien", "Kylie",
			"Asir", "Theresa",
			"Josh", "Sandra",
			"Rory", "Yoshio")
			.map(name -> new Person(null, name))
			.forEach(this.repository::save);

		this.repository.findAll().forEach(System.out::println);

	}
}

interface PersonRepository extends MongoRepository<Person, Integer> {

}

@Data
@AllArgsConstructor
@NoArgsConstructor
class Person {

	@Id
	private String id;
	private String name;

}