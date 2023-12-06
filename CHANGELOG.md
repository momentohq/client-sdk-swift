# Changelog

## [0.3.0](https://github.com/momentohq/client-sdk-swift/compare/v0.2.1...v0.3.0) (2023-12-06)


### Features

* add list collection type ([#66](https://github.com/momentohq/client-sdk-swift/issues/66)) ([1f382c6](https://github.com/momentohq/client-sdk-swift/commit/1f382c641ee1af0db3f5f126cbc0c021917e5825))
* implement CacheClient ([#58](https://github.com/momentohq/client-sdk-swift/issues/58)) ([36d1db1](https://github.com/momentohq/client-sdk-swift/commit/36d1db12523c28c1ed7e751474a3c29535525022))


### Bug Fixes

* add missing error handling for JWT token and tests ([#68](https://github.com/momentohq/client-sdk-swift/issues/68)) ([0599fa0](https://github.com/momentohq/client-sdk-swift/commit/0599fa0586be083e0513dd6ed479ed0d23f4d020))
* exclude protos from target to quiet compiler warning ([#69](https://github.com/momentohq/client-sdk-swift/issues/69)) ([b0ee9e2](https://github.com/momentohq/client-sdk-swift/commit/b0ee9e23a7c5d81ee22ff33b0fe410c2aeaf4732))
* logging for momento clients ([#72](https://github.com/momentohq/client-sdk-swift/issues/72)) ([5ffea92](https://github.com/momentohq/client-sdk-swift/commit/5ffea92c6f1f2efbfe1480a161b104a807c79bb0))


### Miscellaneous

* add dependabot yml ([#74](https://github.com/momentohq/client-sdk-swift/issues/74)) ([f816073](https://github.com/momentohq/client-sdk-swift/commit/f8160736c05e54bb1692f3c1737f1251d69c5d12))
* add example ios chat app using Momento Topics ([#63](https://github.com/momentohq/client-sdk-swift/issues/63)) ([4f58e2a](https://github.com/momentohq/client-sdk-swift/commit/4f58e2af659f1a292d13b202ba3fb4abf7ae02eb))
* add extension for ttl-less set call ([#67](https://github.com/momentohq/client-sdk-swift/issues/67)) ([821d098](https://github.com/momentohq/client-sdk-swift/commit/821d098891817d7a90a28a28e1d6ec262b2f5c1d))
* capitalize module name ([#73](https://github.com/momentohq/client-sdk-swift/issues/73)) ([463e739](https://github.com/momentohq/client-sdk-swift/commit/463e739f037166ff45c95c2e2f19cc4a8e85dec1))
* remove unnecessary imports and namespacing prefixes ([#70](https://github.com/momentohq/client-sdk-swift/issues/70)) ([4872d94](https://github.com/momentohq/client-sdk-swift/commit/4872d945843de56c67dfc7fce07086e1498e4130))
* remove validation disallowing empty and blank cache values ([#71](https://github.com/momentohq/client-sdk-swift/issues/71)) ([4e81fbe](https://github.com/momentohq/client-sdk-swift/commit/4e81fbee82c0a1e63ac1392b01b3ea0bea3e1601))
* topics example should consume package from url and github actions should build example in ci ([#64](https://github.com/momentohq/client-sdk-swift/issues/64)) ([06e598b](https://github.com/momentohq/client-sdk-swift/commit/06e598bb57941fd5fcf5de50543a78a287c83db3))

## [0.2.1](https://github.com/momentohq/client-sdk-swift/compare/v0.2.0...v0.2.1) (2023-11-22)


### Bug Fixes

* available tags should include iOS 13 ([#62](https://github.com/momentohq/client-sdk-swift/issues/62)) ([75a3035](https://github.com/momentohq/client-sdk-swift/commit/75a30350f9c797e37a2faf163206d1679118ca11))
* cast matches in case statements ([#51](https://github.com/momentohq/client-sdk-swift/issues/51)) ([2653331](https://github.com/momentohq/client-sdk-swift/commit/2653331d880e81217405095b30d3e5ce8baeeeef))
* re-enable credential provider tests using mock tokens ([#57](https://github.com/momentohq/client-sdk-swift/issues/57)) ([4163bc3](https://github.com/momentohq/client-sdk-swift/commit/4163bc3d40935a66fcf4051e904984609ecc4b80))

## [0.2.0](https://github.com/momentohq/client-sdk-swift/compare/v0.1.0...v0.2.0) (2023-11-17)


### Features

* add sdk errors ([#14](https://github.com/momentohq/client-sdk-swift/issues/14)) ([5c361a8](https://github.com/momentohq/client-sdk-swift/commit/5c361a86e4e68242b42a473de82418d0c90a6c19))
* protos ([4b878a3](https://github.com/momentohq/client-sdk-swift/commit/4b878a38cb63a36dff30357258683422f4589221))
* topic client and first test ([fb206da](https://github.com/momentohq/client-sdk-swift/commit/fb206da28696fe5c3fab1b52bb13fd803473f333))
* topics configurations classes ([#9](https://github.com/momentohq/client-sdk-swift/issues/9)) ([41e1e0b](https://github.com/momentohq/client-sdk-swift/commit/41e1e0b127bb78fb536b0198039bd46e3cec670c))
* topics subscribe ([#34](https://github.com/momentohq/client-sdk-swift/issues/34)) ([00d8037](https://github.com/momentohq/client-sdk-swift/commit/00d80372399b73bb4499e4c24d8d48db8b38d787))


### Bug Fixes

* add missing signature to protocol ([#49](https://github.com/momentohq/client-sdk-swift/issues/49)) ([c13f86e](https://github.com/momentohq/client-sdk-swift/commit/c13f86e9933e8e0170389ea036fe5b728cc853c5))
* update project namespace to momento ([#33](https://github.com/momentohq/client-sdk-swift/issues/33)) ([1d7dbe1](https://github.com/momentohq/client-sdk-swift/commit/1d7dbe10ea9bd2f2fecacdb6611f47fffcdb6c1c))


### Miscellaneous

* add pattern ex for binary as well as text messages ([#48](https://github.com/momentohq/client-sdk-swift/issues/48)) ([cde72b6](https://github.com/momentohq/client-sdk-swift/commit/cde72b68bf4bb7b63822be27e1cb4406aa1d0358))
* add publish response class and polish publish methods ([#23](https://github.com/momentohq/client-sdk-swift/issues/23)) ([1ec3d53](https://github.com/momentohq/client-sdk-swift/commit/1ec3d53a202c3523de057bb0e0197dcce5abbf55))
* add reusable validation methods ([#43](https://github.com/momentohq/client-sdk-swift/issues/43)) ([3d67278](https://github.com/momentohq/client-sdk-swift/commit/3d67278b4c051e40ea194e919cd54bb28a84c1bf))
* add safeguard to example ([#45](https://github.com/momentohq/client-sdk-swift/issues/45)) ([d71e3a9](https://github.com/momentohq/client-sdk-swift/commit/d71e3a929051955b48021e2df82d41fd844ffa57))
* add support for publishing binary data ([#41](https://github.com/momentohq/client-sdk-swift/issues/41)) ([ef0558e](https://github.com/momentohq/client-sdk-swift/commit/ef0558eb8fe5760038e9888c3b2f76e93e7bc38b))
* adding credential providers ([cc62288](https://github.com/momentohq/client-sdk-swift/commit/cc62288f3342bb26766a8786461e1671ddc258f8))
* finishing initial credential provider impl ([2f4f72b](https://github.com/momentohq/client-sdk-swift/commit/2f4f72b060c4cfe4a59d73bf99cc968ef8bb525f))
* hook up client timeout and add agent header ([#35](https://github.com/momentohq/client-sdk-swift/issues/35)) ([8a40df4](https://github.com/momentohq/client-sdk-swift/commit/8a40df4f66ef9f5b9dc769ca86f447220bc4a4e4))
* readme and contrib ([#44](https://github.com/momentohq/client-sdk-swift/issues/44)) ([1b98eb8](https://github.com/momentohq/client-sdk-swift/commit/1b98eb8503fc292c2acbd49c655757ff51702ac0))
* remove base class; add custom exception ([405b633](https://github.com/momentohq/client-sdk-swift/commit/405b633f8eb1f6a395b3e95f8b1d36425819c157))
* reorganize protocols and classes into same files to be more idiomatic ([#16](https://github.com/momentohq/client-sdk-swift/issues/16)) ([d5eb625](https://github.com/momentohq/client-sdk-swift/commit/d5eb6259780a22a796458bc339b1ea2a08071e94))
* take cred provider out of interceptor factories ([#37](https://github.com/momentohq/client-sdk-swift/issues/37)) ([0f95bd5](https://github.com/momentohq/client-sdk-swift/commit/0f95bd54bfa4fed93b21ce60f5de005354ee4fac))
* tweaking access protection ([d165146](https://github.com/momentohq/client-sdk-swift/commit/d1651464d2dc3f53bda2104e278cdf3952d5f4d2))
* use enums to namespace prebuilt configurations ([0617ec0](https://github.com/momentohq/client-sdk-swift/commit/0617ec02e58c1949d0f409d7f609008a67b663ef))
* use logger that prints to stderr ([#42](https://github.com/momentohq/client-sdk-swift/issues/42)) ([884a24a](https://github.com/momentohq/client-sdk-swift/commit/884a24af11e0608cc7756e5c71f3b4efbe616443))
