# Changelog

## [0.8.1](https://github.com/momentohq/client-sdk-swift/compare/v0.8.0...v0.8.1) (2025-11-10)


### Bug Fixes

* make TopicClient Sendable and other topics fixes ([#151](https://github.com/momentohq/client-sdk-swift/issues/151)) ([5650423](https://github.com/momentohq/client-sdk-swift/commit/5650423a7423191c1ab392c0bfccf33a7d938e58))

## [0.8.0](https://github.com/momentohq/client-sdk-swift/compare/v0.7.2...v0.8.0) (2025-11-07)


### Features

* upgrade to swift 6 to support strict concurrency ([#149](https://github.com/momentohq/client-sdk-swift/issues/149)) ([332ea4b](https://github.com/momentohq/client-sdk-swift/commit/332ea4b5b5c9b9a5c86fcef4e4da305465e08cea))

## [0.7.2](https://github.com/momentohq/client-sdk-swift/compare/v0.7.1...v0.7.2) (2025-11-04)


### Bug Fixes

* specify platforms in package.swift instead of tags everywhere ([#147](https://github.com/momentohq/client-sdk-swift/issues/147)) ([2b977f9](https://github.com/momentohq/client-sdk-swift/commit/2b977f9ea005708f68c8ec35c7706113bfaf4f67))


### Miscellaneous

* upgrade momento dep in demo chat app example ([#145](https://github.com/momentohq/client-sdk-swift/issues/145)) ([5542cb7](https://github.com/momentohq/client-sdk-swift/commit/5542cb7b2a70d0ebf31893c10f436768ad80a666))

## [0.7.1](https://github.com/momentohq/client-sdk-swift/compare/v0.7.0...v0.7.1) (2024-11-26)


### Bug Fixes

* use [@available](https://github.com/available) tag instead of if statement in processError ([#143](https://github.com/momentohq/client-sdk-swift/issues/143)) ([a87e465](https://github.com/momentohq/client-sdk-swift/commit/a87e465401be38fc502da1d04f8d32cf70a250f7))

## [0.7.0](https://github.com/momentohq/client-sdk-swift/compare/v0.6.0...v0.7.0) (2024-11-26)


### Features

* add topic sequence page ([#142](https://github.com/momentohq/client-sdk-swift/issues/142)) ([2a868be](https://github.com/momentohq/client-sdk-swift/commit/2a868be00f39af4dc370741699411e916357cf0c))


### Miscellaneous

* improve resource exhausted error message ([#139](https://github.com/momentohq/client-sdk-swift/issues/139)) ([aa63dec](https://github.com/momentohq/client-sdk-swift/commit/aa63dec407eada6decd941285097fd103292f83f))
* update license file ([#140](https://github.com/momentohq/client-sdk-swift/issues/140)) ([fc6862d](https://github.com/momentohq/client-sdk-swift/commit/fc6862dfc471d17c46aa4a120ba00a1676520147))

## [0.6.0](https://github.com/momentohq/client-sdk-swift/compare/v0.5.1...v0.6.0) (2024-06-20)


### Features

* add onetime headers ([#136](https://github.com/momentohq/client-sdk-swift/issues/136)) ([6312e4c](https://github.com/momentohq/client-sdk-swift/commit/6312e4c8bfb57729737c8539456230d021482b93))

## [0.5.1](https://github.com/momentohq/client-sdk-swift/compare/v0.5.0...v0.5.1) (2024-03-14)


### Bug Fixes

* pass errors as innerException and don't auto-resubscribe when connection becomes unavailable ([#134](https://github.com/momentohq/client-sdk-swift/issues/134)) ([2a5c77b](https://github.com/momentohq/client-sdk-swift/commit/2a5c77b592983ebbcf8b72e42d996572672e12fb))

## [0.5.0](https://github.com/momentohq/client-sdk-swift/compare/v0.4.0...v0.5.0) (2024-01-30)


### Features

* add close method to CacheClient ([#133](https://github.com/momentohq/client-sdk-swift/issues/133)) ([41c7a08](https://github.com/momentohq/client-sdk-swift/commit/41c7a086e42c8fa99850febe71bfc1664938b735))


### Bug Fixes

* remove defaultConfig configurations ([#132](https://github.com/momentohq/client-sdk-swift/issues/132)) ([501ffe5](https://github.com/momentohq/client-sdk-swift/commit/501ffe51566ff172f46ff3714a4c852905c3c8b9))


### Miscellaneous

* readme template was missing code block markdown for usage section ([#128](https://github.com/momentohq/client-sdk-swift/issues/128)) ([7746335](https://github.com/momentohq/client-sdk-swift/commit/7746335dd1cb11436d0d0851d509a970c2d65950))
* send agent header only on first request for each client ([#131](https://github.com/momentohq/client-sdk-swift/issues/131)) ([7b8d213](https://github.com/momentohq/client-sdk-swift/commit/7b8d21389b196dd0792014c3d56c2f40519e7a0c))
* update examples to use latest release and other small updates ([#124](https://github.com/momentohq/client-sdk-swift/issues/124)) ([905f508](https://github.com/momentohq/client-sdk-swift/commit/905f508c666d895622461ef5890d8d6c4cbeaed0))

## [0.4.0](https://github.com/momentohq/client-sdk-swift/compare/v0.3.2...v0.4.0) (2024-01-05)


### Features

* topics subscription resiliency ([#119](https://github.com/momentohq/client-sdk-swift/issues/119)) ([118ac02](https://github.com/momentohq/client-sdk-swift/commit/118ac02aea5fa2c41a52c0c2ad1b781f8e737605))


### Bug Fixes

* add available attribute to cache client protocols ([#120](https://github.com/momentohq/client-sdk-swift/issues/120)) ([2ad256e](https://github.com/momentohq/client-sdk-swift/commit/2ad256e1ceb1de0754c8c37cf2a06e8c04013c38))
* availability tag and topics subscriptions fixes ([#122](https://github.com/momentohq/client-sdk-swift/issues/122)) ([8dad389](https://github.com/momentohq/client-sdk-swift/commit/8dad38947891ef9d94aa0f5df46ab51a05a89e68))


### Miscellaneous

* add code snippets for dev docs ([#107](https://github.com/momentohq/client-sdk-swift/issues/107)) ([929e55d](https://github.com/momentohq/client-sdk-swift/commit/929e55dc31a6dc9b8f36b58caa62f8357a2460e9))
* add examples readme and update readme generator ([#121](https://github.com/momentohq/client-sdk-swift/issues/121)) ([6ab8db5](https://github.com/momentohq/client-sdk-swift/commit/6ab8db56f82f5f830002f2d7311104d315b1f344))
* fix up some wording about examples ([#118](https://github.com/momentohq/client-sdk-swift/issues/118)) ([1b5180e](https://github.com/momentohq/client-sdk-swift/commit/1b5180ea1f744c81f5766811ea238f5e76bd7892))
* rename topics doc sample snippets ([#113](https://github.com/momentohq/client-sdk-swift/issues/113)) ([5e79e91](https://github.com/momentohq/client-sdk-swift/commit/5e79e91b4d9307ce544889277e5bd21bc5fa9e4a))
* small error message and docstring fixes ([#123](https://github.com/momentohq/client-sdk-swift/issues/123)) ([1f5ba6c](https://github.com/momentohq/client-sdk-swift/commit/1f5ba6c6bb450638f73b3695125ca45de607a058))
* swich stability badge from alpha to beta ([#117](https://github.com/momentohq/client-sdk-swift/issues/117)) ([99f4802](https://github.com/momentohq/client-sdk-swift/commit/99f480257c27fdd87e563d8e5c07bb81e1632230))
* update examples ([#108](https://github.com/momentohq/client-sdk-swift/issues/108)) ([2a1526f](https://github.com/momentohq/client-sdk-swift/commit/2a1526fb693255c5a8e6230d36aeb6bb7007df67))

## [0.3.2](https://github.com/momentohq/client-sdk-swift/compare/v0.3.1...v0.3.2) (2023-12-13)


### Bug Fixes

* actually build the topics example in ci ([#105](https://github.com/momentohq/client-sdk-swift/issues/105)) ([3151ee7](https://github.com/momentohq/client-sdk-swift/commit/3151ee7648a923c2d20aed9ae85edb54e0521c76))
* allow users to provide String and Data values directly ([#94](https://github.com/momentohq/client-sdk-swift/issues/94)) ([abdb54c](https://github.com/momentohq/client-sdk-swift/commit/abdb54c530e97f6d8c1da392d8b15778314ad587))
* only topic publish should apply client timeout ([#91](https://github.com/momentohq/client-sdk-swift/issues/91)) ([d7e847e](https://github.com/momentohq/client-sdk-swift/commit/d7e847ecca7f47ed7d270862be58a896990035a7))


### Miscellaneous

* add custom strings to print response types and values if applicable ([#103](https://github.com/momentohq/client-sdk-swift/issues/103)) ([8c2895a](https://github.com/momentohq/client-sdk-swift/commit/8c2895ad9e3dd0d4d03e031b480413cdf877a9d6))
* add docstrings ([#104](https://github.com/momentohq/client-sdk-swift/issues/104)) ([bec7bcc](https://github.com/momentohq/client-sdk-swift/commit/bec7bcc7cd93698b7e9ede689c97a5b13e141a91))
* add validator to check for empty lists ([#95](https://github.com/momentohq/client-sdk-swift/issues/95)) ([b121eb7](https://github.com/momentohq/client-sdk-swift/commit/b121eb79ad7e97903b0a432b76fcbc45f3129627))
* consistent available tags for CacheClient and TopicClient ([#96](https://github.com/momentohq/client-sdk-swift/issues/96)) ([ca66689](https://github.com/momentohq/client-sdk-swift/commit/ca66689f0d386fb76e6d3017804fd03cde444b65))
* improve pattern matching experience for response types ([#90](https://github.com/momentohq/client-sdk-swift/issues/90)) ([25247e5](https://github.com/momentohq/client-sdk-swift/commit/25247e5f6aa30840f496911ca6b7265ab5e2ffeb))
* provide better error message when credential provider fails ([#93](https://github.com/momentohq/client-sdk-swift/issues/93)) ([413e895](https://github.com/momentohq/client-sdk-swift/commit/413e895ea81a0e9405501a74535ec69717a2edd2))
* rename prebuilt config classes and targets for clarity ([#101](https://github.com/momentohq/client-sdk-swift/issues/101)) ([90cd30f](https://github.com/momentohq/client-sdk-swift/commit/90cd30fb4f3e8accb47b2b5df9280fa8470a8687))
* topics related renamings for clarity ([#98](https://github.com/momentohq/client-sdk-swift/issues/98)) ([a461dad](https://github.com/momentohq/client-sdk-swift/commit/a461dad5d2fc14836cd3ef47b748d5b7c272756b))
* update readme instructions for including Momento in Package.swift file ([#97](https://github.com/momentohq/client-sdk-swift/issues/97)) ([b541f8b](https://github.com/momentohq/client-sdk-swift/commit/b541f8b961134ab595a4372e6a77cc3602a7b852))

## [0.3.1](https://github.com/momentohq/client-sdk-swift/compare/v0.3.0...v0.3.1) (2023-12-06)


### Miscellaneous

* add docstrings to cache and topic clients ([#76](https://github.com/momentohq/client-sdk-swift/issues/76)) ([73f6a5f](https://github.com/momentohq/client-sdk-swift/commit/73f6a5f9dd2cf2355c0f315022f0ab396a37e484))

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
