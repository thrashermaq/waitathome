## Inspiration
The measures of the federal government states:
> These establishments must follow the rules on hygiene and social distancing. This can mean, for example, that the number of people present must be limited so as to allow people to keep their distance."

Link: https://www.bag.admin.ch/bag/en/home/krankheiten/ausbrueche-epidemien-pandemien/aktuelle-ausbrueche-epidemien/novel-cov/massnahmen-des-bundes.html

Many shops use paper tickets to control the number of customers. The ticket is handed from person to person which isn't a safe way! As a customer, there is no way to know the current capacity of your shop. You leave your home to do your necessary purchases and risk to get in crowds of people waiting in front of the shop. We came up with a solution for this problem which is called WaitAtHome.

## What it does
Create a save environment for both customers and employees in stores by reducing the number of people in stores and eliminate huge queues in front of stores.

### Shops
WaitAtHome is a convenient solution for stores to track how many people are inside.

<p align="center">
    <img src="https://github.com/thrashermaq/waitathome/blob/feature/typos/gifs/Shop2.gif?raw=true" title="shop journey">
</p>

### Customers
For people who want to do grocery shopping it offers an easy way to check if it is worth going to the shops or to #stayathome.

<p align="center">
    <img width="600px" src="https://github.com/thrashermaq/waitathome/blob/feature/typos/gifs/customer_low.gif?raw=true" title="customer journey">
</p>

## How I built it
We built the app with the cross-platform framework Flutter. Currently the app is working on Android an iOS but it cloud also be used for mobile or desktop apps. We used Firebase with Firestore to get real-time updates on the tracked customers in stores.

## Challenges I ran into
Ideation:
* It wasn't easy to find an idea. There are already a lot of great projects like neighbourhood help apps or voluntary work out there to fight COVID-19.
* It was our first Hackaton so we had to find some tools which support our work together. Miro and Trello worked great!

In development:
* Most of the developers had to learn Dart and Flutter first.

## Accomplishments that we're proud of
* We created a working app for Android and iOS within two days
* Our own logo with a recognition value
* The idea

## What we learned
* When you work for so many hours a relaxed work environment and fun in the team is key
* Extensive brainstorming and sleep over the idea is great
* Regular calls are important to keep each other updated
* We had a great experience on our first Hackaton

## What's next for WaitAtHome
* Finish and share the app
* Fight COVID-19

## Others

### Setup
- run `flutter packages get`
- run `flutter pub run build_runner build` to create json converter methods

### Things to know
- Always run `flutter pub run build_runner build --delete-conflicting-outputs` when a model changed!!

### The boys
App was created by the hacking boys Nils, Hoang, Luca and Ralf