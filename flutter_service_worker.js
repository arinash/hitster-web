'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "1f9780ff7f02c1854eb1a5128d67fc44",
"version.json": "fb1dee26b55a10d3e4a715305459725e",
"index.html": "34242efe324dbfec7427f98741293099",
"/": "34242efe324dbfec7427f98741293099",
"main.dart.js": "7ce215f3c5fa04dfd55e96597af696ca",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "00da648e0a4348482d4c55b3d9537bdc",
".git/ORIG_HEAD": "9fb65c04277bd8974b46d157677e5471",
".git/config": "74b7a304aad0b0a18d014799a5c503d0",
".git/objects/50/8228d7519d142c6980c86986fb61122e2c82ef": "da145d4a7fe54edba6a3a5902caf7d03",
".git/objects/9b/a98eba2fdd58a131db4e006cb79374eb1ebab8": "23e2b35d065b58b8c2b8adb56bf44b1d",
".git/objects/9b/3ef5f169177a64f91eafe11e52b58c60db3df2": "91d370e4f73d42e0a622f3e44af9e7b1",
".git/objects/9e/aa7394d05f63fc6c545249b301dc6973a30103": "41ebe1cb558feb4436aae84f3fb78523",
".git/objects/9e/3b4630b3b8461ff43c272714e00bb47942263e": "accf36d08c0545fa02199021e5902d52",
".git/objects/04/d2a32f5757aea4abe9ec68804bbf858028c85d": "bcb0aac6e37d62efc358db92f1b3b5de",
".git/objects/3d/96ed0cf096526933929e4fecbe8dd184093549": "86e8c09ea468f075b47a2a1c46c04018",
".git/objects/d7/7cfefdbe249b8bf90ce8244ed8fc1732fe8f73": "9c0876641083076714600718b0dab097",
".git/objects/be/b1a558bf51f5f2a368273ddb7dd820691b0de1": "8c1f8045609ff574ce10afc82ede2241",
".git/objects/b3/d76e8edc8dd29b86aeb7c09967c0ab18f30148": "adf02742fbcc74530d6232bafd129115",
".git/objects/da/0d5aa44a8c93eda469f7a99ed8feac32d5b19d": "25d25e93b491abda0b2b909e7485f4d1",
".git/objects/da/cb3d9afc32895742f80c40ce8d40046db0606b": "fd3911edc805126d3488ad4132b87ced",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/d8/8128adaad90d2fd7cdabe7b36eaaaed0d3a25b": "3d15963af0d77c1cd40702fb7c18fa93",
".git/objects/e2/a7d91cbded5a23cea3a597cfafeea717580471": "57eb07df2b9ae99316b39858eed8e2ba",
".git/objects/e2/877256f722ac1faadd3e99e164255175afb1f8": "247c24710fa95d0e108081c6a775c57f",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/f5/72b90ef57ee79b82dd846c6871359a7cb10404": "e68f5265f0bb82d792ff536dcb99d803",
".git/objects/ca/3bba02c77c467ef18cffe2d4c857e003ad6d5d": "316e3d817e75cf7b1fd9b0226c088a43",
".git/objects/fe/3b987e61ed346808d9aa023ce3073530ad7426": "dc7db10bf25046b27091222383ede515",
".git/objects/ed/b55d4deb8363b6afa65df71d1f9fd8c7787f22": "886ebb77561ff26a755e09883903891d",
".git/objects/20/3a3ff5cc524ede7e585dff54454bd63a1b0f36": "4b23a88a964550066839c18c1b5c461e",
".git/objects/20/fb39a3893ddf7c910e524953c4630a78d31eba": "355c4687cd41368b8764e078f0d7ab3d",
".git/objects/18/688c8addcc20d900343aa5cd5afd84125a866e": "486fb1501757084d4557cb03cf67c811",
".git/objects/29/942f8344adc68935218cb871f5eb7da513a4ae": "0b717fb39524da7a64ba0d44286b72a4",
".git/objects/29/f22f56f0c9903bf90b2a78ef505b36d89a9725": "e85914d97d264694217ae7558d414e81",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/4c/760d4b725a96988bc826a2d3a44d84562fc7d1": "ba817dd138947196924a84e34b50a16e",
".git/objects/4d/bf9da7bcce5387354fe394985b98ebae39df43": "534c022f4a0845274cbd61ff6c9c9c33",
".git/objects/2a/fcc8c9d9e29bcf9ac1af54709f232cc06184ea": "169bcc1b89a78a68a4d50c3c8573d50e",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/6b/9862a1351012dc0f337c9ee5067ed3dbfbb439": "85896cd5fba127825eb58df13dfac82b",
".git/objects/38/d27aa2a189e776201f229c37ba5303d78905ba": "70f924a0457c8b4b3a7c7d40e6a42aff",
".git/objects/38/d19f8d0f702c3940132601fb1e932ff4dedae0": "6bccfa76d187329e66a1c53710fac057",
".git/objects/65/c837751a1bc610df552fcca322d258cb1cf3d5": "b910735fc6a443bb60fa197a480194ae",
".git/objects/98/0d49437042d93ffa850a60d02cef584a35a85c": "8e18e4c1b6c83800103ff097cc222444",
".git/objects/5e/f8c22bef0c2888229f71ee80c073d71ba7a5e7": "6bbca67bcdc8078ac5f4186762a9e71c",
".git/objects/39/b8814aecf8ec43997e2093cfcb4cb739f8d705": "fb85de87c79af0fd83e29071fc246467",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/dc/45b4c7f1cd5a73411b607fc860e80dc371365e": "cb4446276c932e0853ead3d7bc625b36",
".git/objects/b6/b8806f5f9d33389d53c2868e6ea1aca7445229": "b14016efdbcda10804235f3a45562bbf",
".git/objects/b6/14811558aad81bc29c8390d43f9874c5efffee": "b011b90041025b8ca4f7a97532dea05b",
".git/objects/d2/3b19a271b6f6e70f98df870687cf87de0d84ee": "5eae51265f52ba43e3f5ea0fe7fb0e00",
".git/objects/af/ed46055d1eb74674183d2ad9aa341d2d393762": "15ab8f83f2155a5e4841cb635f6890d2",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/a8/48e77a2ecb2018f1cd8dab7e367b2a94e51f83": "f0ad73fe62b3715d2b8668dc51a31add",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/c4/016f7d68c0d70816a0c784867168ffa8f419e1": "fdf8b8a8484741e7a3a558ed9d22f21d",
".git/objects/f7/b83c780a6ca7d725bdbc32ad9025221a830e24": "9673e1443966a8346094b888904c31d7",
".git/objects/e9/94225c71c957162e2dcc06abe8295e482f93a2": "2eed33506ed70a5848a0b06f5b754f2c",
".git/objects/ce/50c888ef3023df81827ed15026cc6173593ec7": "e28e512ef1875f020efd0097767caba5",
".git/objects/83/272988673f925523d5374b3e74cc3d7fe2ef7c": "3e1d141c29ae5cc9d3a576181bf670fa",
".git/objects/77/22c26ab19aa7141dbb501cb86a9ed9934a2128": "23c0691e78393c6d17364522f8fdfb66",
".git/objects/1e/1acfc64432d21f02bc0bb76d27dd35c106a083": "86ac1412dcd88b8f0092b5f490759b0f",
".git/objects/4f/fbe6ec4693664cb4ff395edf3d949bd4607391": "2beb9ca6c799e0ff64e0ad79f9e55e69",
".git/objects/12/474c9f0669eb347a87bac8f0fe1d841ae1df46": "8a3937cc7b07425d998ff9e64dd824d0",
".git/objects/85/b56716afbd7f31958009f8e56d6922a0f8a895": "0009421195b2c3083c577488cee02990",
".git/objects/2e/8f70fbdad9158a8c4a79f14eb5bf31b4f60053": "ede7e03640ed40d5c10dac2d2f8a7127",
".git/objects/7a/6c1911dddaea52e2dbffc15e45e428ec9a9915": "f1dee6885dc6f71f357a8e825bda0286",
".git/objects/25/7f4b21f1bd78669449530d49f1c439fa3f0195": "e01736c8636c28e98c3c96ca653fe3ca",
".git/HEAD": "cf7dd3ce51958c5f13fece957cc417fb",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "534c1e130b29e7c399c3ba527b660e26",
".git/logs/refs/heads/master": "a563f2456dfae5e8265d3338b8275a7c",
".git/logs/refs/heads/main": "450c3098c69a07c64b5b3b69ab80d59d",
".git/logs/refs/remotes/origin/HEAD": "033578b015324438b8136b9302bc5fce",
".git/logs/refs/remotes/origin/master": "7b80e15f9c06666b1a6f612df3130b71",
".git/logs/refs/remotes/origin/main": "4ba634a76e15f7a9ac3a6d7de8e979e0",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/pre-commit.sample": "5029bfab85b1c39281aa9697379ea444",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/refs/heads/master": "dc6a727164ddfb6d6a8e3fbfa1d0a19d",
".git/refs/heads/main": "9fb65c04277bd8974b46d157677e5471",
".git/refs/remotes/origin/HEAD": "98b16e0b650190870f1b40bc8f4aec4e",
".git/refs/remotes/origin/master": "dc6a727164ddfb6d6a8e3fbfa1d0a19d",
".git/refs/remotes/origin/main": "9fb65c04277bd8974b46d157677e5471",
".git/index": "b93b006d28828dc1d32f5e7201552c98",
".git/COMMIT_EDITMSG": "1bd341722e3b32e9ed402a114f97b3bc",
".git/FETCH_HEAD": "d41d8cd98f00b204e9800998ecf8427e",
"assets/AssetManifest.json": "e3309d93758988f1f1d0a743de4122f4",
"assets/NOTICES": "2aae7d3756d61c3a846f57d92fd24f0b",
"assets/FontManifest.json": "1052b45602d67b78c14a1c68bb7b96aa",
"assets/AssetManifest.bin.json": "bd7e58a48779a9bdd699311fe112b7b2",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "6d897457e6644a88e06c3135ef00f0fa",
"assets/fonts/MaterialIcons-Regular.otf": "2902b56e4b535e6da56a69a50316702d",
"assets/assets/images/win.png": "af1c59d72ebaee13ef516a1cb9f76005",
"assets/assets/images/guessed.png": "104b3f0bc3ec5100bcf3c282c8e5a206",
"assets/assets/images/guess.png": "be1caaedf346730cabcf1a02dacd8137",
"assets/assets/images/micro.png": "03299f90f7b2df53084ca5569a33109f",
"assets/assets/images/coinsLoose.png": "0ccdb23e55d011d2b1383f3dfc29245d",
"assets/assets/images/coinsAdd.png": "42cbd7b54fb7a87f7ddbf3c2f4d31202",
"assets/assets/images/scan.png": "2f1f0ce3245150b340a2835fd3241e60",
"assets/assets/images/coins.png": "76f1cb1709fa275d63239e0335f527b4",
"assets/assets/images/bg.png": "d08df1c26d106509f91366d2bf73e673",
"assets/assets/fonts/swanky-and-moo-moo.otf": "30a7df674792a372b4940d7757a111cf",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
