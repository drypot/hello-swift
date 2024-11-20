//
//  ObservableArrayTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 11/19/24.
//

import Foundation
import Testing

struct ObservableArrayTests {

    struct Product {
        var name: String
    }

    class RefProduct {
        var name: String = ""

        init(name: String) {
            self.name = name
        }
    }

    @Observable class ObservableProduct {
        var name: String

        init(name: String) {
            self.name = name
        }
    }

    @Observable class Products {
        var valueProducts: [Product] = []
        var refProducts: [RefProduct] = []
        var observableProducts: [ObservableProduct] = []
    }

    @Test func testObservableArrayOfValues() async throws {

        // 어레이 자체의 변화에 onChange 가 호출된다.

        await confirmation { confirm in
            let products = Products()
            products.valueProducts.append(Product(name: "Item1"))

            withObservationTracking {
                _ = products.valueProducts
            } onChange: {
                confirm()
            }

            products.valueProducts.append(Product(name: "Item2"))
        }

        // 밸류 엘리먼트 변화에 onChange 가 호출된다.

        await confirmation { confirm in
            let products = Products()
            products.valueProducts.append(Product(name: "Item1"))

            withObservationTracking {
                _ = products.valueProducts
            } onChange: {
                confirm()
            }

            products.valueProducts[0].name = "Item1Ver2"
        }

        // 업데이트가 여러번 발생해도 onChange 는 한번만 호출된다.

        await confirmation(expectedCount: 1) { confirm in
            let products = Products()
            products.valueProducts.append(Product(name: "Item1"))

            withObservationTracking {
                _ = products.valueProducts
            } onChange: {
                confirm()
            }

            products.valueProducts.append(Product(name: "Item2"))
            products.valueProducts.append(Product(name: "Item3"))
            products.valueProducts.append(Product(name: "Item4"))
        }
    }

    @Test func testObservableArrayOfObjects() async throws {

        // 어레이 자체의 변화에 onChange 가 호출된다.

        await confirmation { confirm in
            let products = Products()
            products.refProducts.append(RefProduct(name: "Item1"))

            withObservationTracking {
                _ = products.refProducts
            } onChange: {
                confirm()
            }

            products.refProducts.append(RefProduct(name: "Item2"))
        }

        // 오브젝트 엘리먼트에 대한 업데이트엔 onChange 가 발생하지 않는다.

        await confirmation(expectedCount: 0) { confirm in
            let products = Products()
            products.refProducts.append(RefProduct(name: "Item1"))

            withObservationTracking {
                _ = products.refProducts
            } onChange: {
                confirm()
            }

            products.refProducts[0].name = "Item1Ver2"
        }

        await confirmation(expectedCount: 0) { confirm in
            let products = Products()
            products.refProducts.append(RefProduct(name: "Item1"))

            withObservationTracking {
                let product = products.refProducts[0]
                _ = product.name
            } onChange: {
                confirm()
            }

            products.refProducts[0].name = "Item1Ver2"
        }

    }

    @Test func testObservableArrayOfObservableObjects() async throws {

        // 어레이 자체의 변화에 onChange 가 호출된다.

        await confirmation { confirm in
            let products = Products()
            products.observableProducts.append(ObservableProduct(name: "Item1"))

            withObservationTracking {
                _ = products.observableProducts
            } onChange: {
                confirm()
            }

            products.observableProducts.append(ObservableProduct(name: "Item2"))
        }

        // 오브젝트 엘리먼트에 대한 업데이트엔 onChange 가 발생하지 않는다.

        await confirmation(expectedCount: 0) { confirm in
            let products = Products()
            products.observableProducts.append(ObservableProduct(name: "Item1"))

            withObservationTracking {
                _ = products.observableProducts
            } onChange: {
                confirm()
            }

            products.observableProducts[0].name = "Item1Ver2"
        }

        // 오브젝트 엘리먼트를 구체적으로 노출시켜주면 onChange 가 발생한다.

        await confirmation { confirm in
            let products = Products()
            products.observableProducts.append(ObservableProduct(name: "Item1"))

            withObservationTracking {
                let product = products.observableProducts[0]
                _ = product.name
            } onChange: {
                confirm()
            }

            products.observableProducts[0].name = "Item1Ver2"
        }

    }
}
