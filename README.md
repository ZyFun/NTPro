
![Xcode](https://img.shields.io/badge/Xcode-007ACC?style=for-the-badge&logo=Xcode&logoColor=white)
![Swift](https://img.shields.io/badge/swift-F54A2A?style=for-the-badge&logo=swift&logoColor=white)
![IOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)
<br/>
![Target](https://img.shields.io/badge/iOS-13.0-blue)
![Version](https://img.shields.io/badge/version-1.0.0-blue)
<br/>
![UIKit](https://img.shields.io/badge/-UIKit-blue)
![UITableViewDiffableDataSource](https://img.shields.io/badge/-UITableViewDiffableDataSource-blue)
![MVP](https://img.shields.io/badge/-MVP-blue)
![GCD](https://img.shields.io/badge/-GCD-blue)
![AutoLayout](https://img.shields.io/badge/-AutoLayout-blue)

# Работа с большим потоком данных
Тестовое задание

## Description
Очень удобно использовать в мороз для согрева рук, или утром чтобы пожарить яичницу. 
<br/>
<br/>
Каждые 2 секунды формируется коллекция примерно с 2000 случайных объектов, у которых могут быть одинаковые ID. Объекты с совпадающими ID заменяются новыми данными. Эти данные сортируются по указанным пользователем данным. Приложение сделано так, что даже с 300 000 объектов, интерфейс приложения не тормозит и пользователю комфортно с ним работать.

### Описание используемых технологий
- Алгоритмы и структуры данных, для оптимизации работы на сколько это было возможно с таким потоком данных.
- Многопоточность приложения построена на **GCD**.
- Приложение написано на архитектуре **MVP**.
- Вместо стандартного data source у теблицы используется **UITableViewDiffableDataSource**
- Вёрстка итерфейса сделана полностью кодом с помощью **AutoLayout**
- Весь дизайн взят из ТЗ.

## Installations
Clone and run project in Xcode 14 or newer

## Screenshots
<img src="https://github.com/ZyFun/NTPro/blob/main/Screenshots/Screenshot000.png" width="252" height="503" /> <img src="https://github.com/ZyFun/NTPro/blob/main/Screenshots/Screenshot001.png" width="252" height="503" />

## Demo
<img src="https://github.com/ZyFun/NTPro/blob/main/Demo/Demo000.gif" width="252" height="545" />
