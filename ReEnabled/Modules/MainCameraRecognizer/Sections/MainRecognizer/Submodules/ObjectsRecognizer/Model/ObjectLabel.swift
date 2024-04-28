enum ObjectLabel {
    case person
    case bicycle
    case car
    case motorbike
    case aeroplane
    case bus
    case train
    case truck
    case boat
    case trafficLight
    case fireHydrant
    case stopSign
    case parkingMeter
    case bench
    case bird
    case cat
    case dog
    case horse
    case sheep
    case cow
    case elephant
    case bear
    case zebra
    case giraffe
    case backpack
    case umbrella
    case handbag
    case tie
    case suitcase
    case frisbee
    case skis
    case snowboard
    case sportsBall
    case kite
    case baseballBat
    case baseballGlove
    case skateboard
    case surfboard
    case tennisRacket
    case bottle
    case wineGlass
    case cup
    case fork
    case knife
    case spoon
    case bowl
    case banana
    case apple
    case sandwich
    case orange
    case broccoli
    case carrot
    case hotDog
    case pizza
    case donut
    case cake
    case chair
    case sofa
    case pottedPlant
    case bed
    case diningTable
    case toilet
    case tvMonitor
    case laptop
    case mouse
    case remote
    case keyboard
    case cellPhone
    case microwave
    case oven
    case toaster
    case sink
    case refrigerator
    case book
    case clock
    case vase
    case scissors
    case teddyBear
    case hairDrier
    case toothbrush
}

extension ObjectLabel {
    var rawValue: String {
        switch self {
        case .person: return MLModelLabelText.objectMLModelPerson.rawValue.localized()
        case .bicycle: return MLModelLabelText.objectMLModelBicycle.rawValue.localized()
        case .car: return MLModelLabelText.objectMLModelCar.rawValue.localized()
        case .motorbike: return MLModelLabelText.objectMLModelMotorbike.rawValue.localized()
        case .aeroplane: return MLModelLabelText.objectMLModelAeroplane.rawValue.localized()
        case .bus: return MLModelLabelText.objectMLModelBus.rawValue.localized()
        case .train: return MLModelLabelText.objectMLModelTrain.rawValue.localized()
        case .truck: return MLModelLabelText.objectMLModelTruck.rawValue.localized()
        case .boat: return MLModelLabelText.objectMLModelBoat.rawValue.localized()
        case .trafficLight: return MLModelLabelText.objectMLModelTrafficLight.rawValue.localized()
        case .fireHydrant: return MLModelLabelText.objectMLModelFireHydrant.rawValue.localized()
        case .stopSign: return MLModelLabelText.objectMLModelStopSign.rawValue.localized()
        case .parkingMeter: return MLModelLabelText.objectMLModelParkingMeter.rawValue.localized()
        case .bench: return MLModelLabelText.objectMLModelBench.rawValue.localized()
        case .bird: return MLModelLabelText.objectMLModelBird.rawValue.localized()
        case .cat: return MLModelLabelText.objectMLModelCat.rawValue.localized()
        case .dog: return MLModelLabelText.objectMLModelDog.rawValue.localized()
        case .horse: return MLModelLabelText.objectMLModelHorse.rawValue.localized()
        case .sheep: return MLModelLabelText.objectMLModelSheep.rawValue.localized()
        case .cow: return MLModelLabelText.objectMLModelCow.rawValue.localized()
        case .elephant: return MLModelLabelText.objectMLModelElephant.rawValue.localized()
        case .bear: return MLModelLabelText.objectMLModelBear.rawValue.localized()
        case .zebra: return MLModelLabelText.objectMLModelZebra.rawValue.localized()
        case .giraffe: return MLModelLabelText.objectMLModelGiraffe.rawValue.localized()
        case .backpack: return MLModelLabelText.objectMLModelBackpack.rawValue.localized()
        case .umbrella: return MLModelLabelText.objectMLModelUmbrella.rawValue.localized()
        case .handbag: return MLModelLabelText.objectMLModelHandbag.rawValue.localized()
        case .tie: return MLModelLabelText.objectMLModelTie.rawValue.localized()
        case .suitcase: return MLModelLabelText.objectMLModelSuitcase.rawValue.localized()
        case .frisbee: return MLModelLabelText.objectMLModelFrisbee.rawValue.localized()
        case .skis: return MLModelLabelText.objectMLModelSkis.rawValue.localized()
        case .snowboard: return MLModelLabelText.objectMLModelSnowboard.rawValue.localized()
        case .sportsBall: return MLModelLabelText.objectMLModelSportsBall.rawValue.localized()
        case .kite: return MLModelLabelText.objectMLModelKite.rawValue.localized()
        case .baseballBat: return MLModelLabelText.objectMLModelBaseballBat.rawValue.localized()
        case .baseballGlove: return MLModelLabelText.objectMLModelBaseballGlove.rawValue.localized()
        case .skateboard: return MLModelLabelText.objectMLModelSkateboard.rawValue.localized()
        case .surfboard: return MLModelLabelText.objectMLModelSurfboard.rawValue.localized()
        case .tennisRacket: return MLModelLabelText.objectMLModelTennisRacket.rawValue.localized()
        case .bottle: return MLModelLabelText.objectMLModelBottle.rawValue.localized()
        case .wineGlass: return MLModelLabelText.objectMLModelWineGlass.rawValue.localized()
        case .cup: return MLModelLabelText.objectMLModelCup.rawValue.localized()
        case .fork: return MLModelLabelText.objectMLModelFork.rawValue.localized()
        case .knife: return MLModelLabelText.objectMLModelKnife.rawValue.localized()
        case .spoon: return MLModelLabelText.objectMLModelSpoon.rawValue.localized()
        case .bowl: return MLModelLabelText.objectMLModelBowl.rawValue.localized()
        case .banana: return MLModelLabelText.objectMLModelBanana.rawValue.localized()
        case .apple: return MLModelLabelText.objectMLModelApple.rawValue.localized()
        case .sandwich: return MLModelLabelText.objectMLModelSandwich.rawValue.localized()
        case .orange: return MLModelLabelText.objectMLModelOrange.rawValue.localized()
        case .broccoli: return MLModelLabelText.objectMLModelBroccoli.rawValue.localized()
        case .carrot: return MLModelLabelText.objectMLModelCarrot.rawValue.localized()
        case .hotDog: return MLModelLabelText.objectMLModelHotDog.rawValue.localized()
        case .pizza: return MLModelLabelText.objectMLModelPizza.rawValue.localized()
        case .donut: return MLModelLabelText.objectMLModelDonut.rawValue.localized()
        case .cake: return MLModelLabelText.objectMLModelCake.rawValue.localized()
        case .chair: return MLModelLabelText.objectMLModelChair.rawValue.localized()
        case .sofa: return MLModelLabelText.objectMLModelSofa.rawValue.localized()
        case .pottedPlant: return MLModelLabelText.objectMLModelPottedPlant.rawValue.localized()
        case .bed: return MLModelLabelText.objectMLModelBed.rawValue.localized()
        case .diningTable: return MLModelLabelText.objectMLModelDiningTable.rawValue.localized()
        case .toilet: return MLModelLabelText.objectMLModelToilet.rawValue.localized()
        case .tvMonitor: return MLModelLabelText.objectMLModelTVMonitor.rawValue.localized()
        case .laptop: return MLModelLabelText.objectMLModelLaptop.rawValue.localized()
        case .mouse: return MLModelLabelText.objectMLModelMouse.rawValue.localized()
        case .remote: return MLModelLabelText.objectMLModelRemote.rawValue.localized()
        case .keyboard: return MLModelLabelText.objectMLModelKeyboard.rawValue.localized()
        case .cellPhone: return MLModelLabelText.objectMLModelCellPhone.rawValue.localized()
        case .microwave: return MLModelLabelText.objectMLModelMicrowave.rawValue.localized()
        case .oven: return MLModelLabelText.objectMLModelOven.rawValue.localized()
        case .toaster: return MLModelLabelText.objectMLModelToaster.rawValue.localized()
        case .sink: return MLModelLabelText.objectMLModelSink.rawValue.localized()
        case .refrigerator: return MLModelLabelText.objectMLModelRefrigerator.rawValue.localized()
        case .book: return MLModelLabelText.objectMLModelBook.rawValue.localized()
        case .clock: return MLModelLabelText.objectMLModelClock.rawValue.localized()
        case .vase: return MLModelLabelText.objectMLModelVase.rawValue.localized()
        case .scissors: return MLModelLabelText.objectMLModelScissors.rawValue.localized()
        case .teddyBear: return MLModelLabelText.objectMLModelTeddyBear.rawValue.localized()
        case .hairDrier: return MLModelLabelText.objectMLModelHairDrier.rawValue.localized()
        case .toothbrush: return MLModelLabelText.objectMLModelToothbrush.rawValue.localized()
        }
    }
}

extension ObjectLabel: CaseIterable {
    static let allCases: [ObjectLabel] = [
        .person, .bicycle, .car, .motorbike, .aeroplane, .bus, .train, .truck, .boat, .trafficLight, .fireHydrant, .stopSign, .parkingMeter, .bench, .bird, .cat, .dog, .horse, .sheep, .cow, .elephant, .bear, .zebra, .giraffe, .backpack, .umbrella, .handbag, .tie, .suitcase, .frisbee, .skis, .snowboard, .sportsBall, .kite, .baseballBat, .baseballGlove, .skateboard, .surfboard, .tennisRacket, .bottle, .wineGlass, .cup, .fork, .knife, .spoon, .bowl, .banana, .apple, .sandwich, .orange, .broccoli, .carrot, .hotDog, .pizza, .donut, .cake, .chair, .sofa, .pottedPlant, .bed, .diningTable, .toilet, .tvMonitor, .laptop, .mouse, .remote, .keyboard, .cellPhone, .microwave, .oven, .toaster, .sink, .refrigerator, .book, .clock, .vase, .scissors, .teddyBear, .hairDrier, .toothbrush
    ]
}
