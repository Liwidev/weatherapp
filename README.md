# weatherapp

Core:
* 2. Error/Failures -> 7. Usecases usecase(Contract - Call()) -> 15. Network/info(contract) -> 17. Error/exceptions(class impl Exception) -> 18. Error/Failures(General Failures) -> [23. Network/info(Imp)]

Domain:
* 1. Entities -> ... -> 3. Repository (Contract) -> 6. Use Cases (Create class with ctr) -> [9. Use Cases(Refactor)]

Data:
* 11. Models(model imp entity) -> 13. Models(refactor) -> 14. Repository (Impl override from contract) -> 16. Datasources (Contracts) -> [21. Repository(refactor)] -> [25. Datasources(refactor) -> ]

Presentation:
* 26.
           
Core_test:
* [22. Network/info(TDD)]

Domain_test:
* 5. Use Cases (setup) -> [8. Use Cases(TDD)]

Data_test:
* 4. Repository (Repo Class Mock) -> 10. Models(check subclass) -> 12. Models(jsonMap & fromJson) -> 19. Repository(Impl Setup) -> [20. Repository(TDD)] -> [24. Datasources(TDD) -> ]

Presentation_test:


