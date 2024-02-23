// Почитать про copy on write (CoW) и понять, что это такое
// Реализовать структуру IOSCollection и создать в ней copy on write по типу - Видео-урок
import Foundation

class IOSCollectionStorage<T> 
{
    var items: [T]
    init(items: [T]) 
    {
        self.items = items
    }
    
    func append(_ item: T) 
    {
        items.append(item)
    }
    
    func get(at index: Int) -> T 
    {
        return items[index]
    }
    
    func set(at index: Int, to item: T) 
    {
        items[index] = item
    }
    
    func count() -> Int 
    {
        return items.count
    }
    
    func copy() -> IOSCollectionStorage<T> 
    {
        return IOSCollectionStorage<T>(items: self.items)
    }
}

struct IOSCollection<T> 
{
    var storage: IOSCollectionStorage<T>
    
    init(storage: IOSCollectionStorage<T>) 
    {
        self.storage = storage
    }
    
    mutating func append(_ item: T) 
    {
        if !isKnownUniquelyReferenced(&storage) 
        {
            storage = storage.copy()
        }
        storage.append(item)
    }
    
    func get(at index: Int) -> T 
    {
        return storage.get(at: index)
    }
    
    mutating func set(at index: Int, to item: T) 
    {
        if !isKnownUniquelyReferenced(&storage) 
        {
            storage = storage.copy()
        }
        storage.set(at: index, to: item)
    }
    
    func count() -> Int
    {
        return storage.count()
    }
}

// Создание и тестирование коллекции
var arr: [String] = ["apple", "banana", "orange", "pear", "grapefruit"]
var collection = IOSCollectionStorage(items: arr)
var collection1 = IOSCollection(storage: collection)
var collection2 = collection1

print(Unmanaged.passUnretained(collection1.storage).toOpaque())
print(Unmanaged.passUnretained(collection2.storage).toOpaque())

collection2.append("lemon")
print("After:")

print(Unmanaged.passUnretained(collection1.storage).toOpaque())
print(Unmanaged.passUnretained(collection2.storage).toOpaque())

// Создать протокол *Hotel* с инициализатором, который принимает roomCount, после создать class HotelAlfa добавить свойство roomCount и подписаться на этот протокол
protocol Hotel 
{
    var roomCount: Int { get }  
    init(roomCount: Int)
}

class HotelAlfa: Hotel 
{
    var roomCount: Int   
    required init(roomCount: Int) 
    {
        self.roomCount = roomCount
    }
}

// Создать protocol GameDice у него {get} свойство numberDice далее нужно расширить Int так, чтобы когда мы напишем такую конструкцию 'let diceCoub = 4 diceCoub.numberDice' в консоле мы увидели такую строку - 'Выпало 4 на кубике'
protocol GameDice 
{
    var numberDice: Int { get }
}
extension Int: GameDice 
{
    var numberDice: Int 
    {
        return self
    }
}
let diceCoub = 4
print("Выпало \(diceCoub.numberDice) на кубике") 
// Создать протокол с одним методом и 2 свойствами одно из них сделать явно optional, создать класс, подписать на протокол и реализовать только 1 обязательное свойство
// import Foundation
// @objc protocol GreetingProtocol {
//     func sayHello()
//     var numberOfGreetings: Int { get }
//     @objc  optional var greetingMessage: String? { get }
// }

// class GreetingClass: GreetingProtocol {
//     func sayHello() {
//         print("Hello")
//     }
//     var numberOfGreetings: Int
    
//     init(numberOfGreetings: Int) {
//         self.numberOfGreetings = numberOfGreetings
//     }
// }

// let greetingClass = GreetingClass(numberOfGreetings: 3)
// greetingClass.sayHello()


// Изучить раздел 'Протоколы -> Делегирование' в документации
// Проработать код из видео
// Создать 2 протокола: со свойствами время, количество кода и функцией writeCode(platform: Platform, numberOfSpecialist: Int); и другой с функцией: stopCoding(). Создайте класс: Компания, у которого есть свойства - количество программистов, специализации(ios, android, web)
// Компании подключаем два этих протокола
// Задача: вывести в консоль сообщения - 'разработка началась. пишем код <такой-то>' и 'работа закончена. Сдаю в тестирование', попробуйте обработать крайние случаи.
protocol CodingProtocol 
{
    var time: Int { get set }   
    var lines_of_code: Int { get set }
    func writeCode(platform: Platform, numberOfSpecialist: Int)
}

protocol StopCodingProtocol
{
    func stopCoding()
}

enum Platform {
    case ios, android, web
}

class Company: CodingProtocol, StopCodingProtocol 
{
    var time: Int
    var lines_of_code: Int
    var programmers: Int
    var specializations: [Platform]
    
    init(programmers: Int, specializations: [Platform]) 
    {
        self.programmers = programmers
        self.specializations = specializations
        self.time = 0
        self.lines_of_code = 0
    }
    
    func writeCode(platform: Platform, numberOfSpecialist: Int) 
    {
        guard specializations.contains(platform) && numberOfSpecialist <= programmers else 
        {
            print("Специалистов не хватает")
            return
        }
        print("Разработка началась. \(numberOfSpecialist) программмистов пишут код для \(platform)")
    }
    
    func stopCoding() 
    {
        print("Работа закончена. Сдаем в тестирование")
    }
}
var platforms = [Platform]()
platforms.append(Platform.ios)
platforms.append(Platform.android)
platforms.append(Platform.web)

let ITCompany=Company(programmers: 10, specializations: platforms)
ITCompany.writeCode(platform: Platform.web, numberOfSpecialist: 12)
ITCompany.writeCode(platform: Platform.android, numberOfSpecialist: 5)
ITCompany.stopCoding()
ITCompany.writeCode(platform: Platform.ios, numberOfSpecialist: 7)
ITCompany.stopCoding()
