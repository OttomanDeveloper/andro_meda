'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  ".git/COMMIT_EDITMSG": "183a521e8a6684fe797a0547e43bcc05",
".git/config": "227efeef09ec49469ac1564d50073369",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/HEAD": "4cf2d64e44205fe628ddd534e1151b58",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "ea587b0fae70333bce92257152996e70",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "305eadbbcd6f6d2567e033ad12aabbc4",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "2bcde69289ce8e1ef60181a294ce1806",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "9f279d72721ca3a835f8941062548cc3",
".git/logs/refs/heads/master": "204b404e609527321dedc252a1e89f79",
".git/logs/refs/remotes/origin/master": "01bbbf95b531d81a9b7d7a384ca38d4a",
".git/objects/01/0ca0a3741d68bb7992b62f6e16d9f215a91618": "539420b86607fdb28ef18d7c935d9837",
".git/objects/04/4c45c38ef5f1b79083b5c520de7ce593d39b6e": "17f9198bcd3dc7d26fd84a609d2c9151",
".git/objects/13/9e22426cd2efe6dc46e34d63c3b72890d092a4": "4b6ea05a49e909f4503a43d44e995ae2",
".git/objects/1b/cac5de92bb2b86b0a6ead3bde5cd10c7d4ddec": "934df22e8fb9c1f05b46795c4e37a6b3",
".git/objects/1e/2ffcf3b3dc51b6282a8e1e506e6dd99ba29e69": "ebec914890a1cc092b869ec2abbb4f75",
".git/objects/1e/8d5b3ff473cdee97b0b02c72f41a63b11665a1": "ec51d334e45696d681502e173326e410",
".git/objects/2a/f769cd41dece5a754ca520ab8652624cfc635d": "b4b16ebd2a6402bc7f2600101ea73b15",
".git/objects/2c/8dfe38acc80bf2beec0c1c705e90463d41039c": "4401ec0fb8cb9c20c69c1f1d22da991c",
".git/objects/32/46ad559eeae0370195978eaed83f1053ee13fd": "a043dbc0a0bda96ce2127799ccc27506",
".git/objects/35/17c2bd87a7cfbf1389b7f66a61a8aa1e8ae236": "bd9484d9755f7aec29280636d8d45bad",
".git/objects/46/4ab5882a2234c39b1a4dbad5feba0954478155": "2e52a767dc04391de7b4d0beb32e7fc4",
".git/objects/52/04cad424fa536d405668fd0e6abb4ff2a8bdb7": "1306b4940c5367e94e9ac8cfe040f0b8",
".git/objects/59/7d6a66031b06fcfe1a95510bad2938982ff060": "16122659960706db329bea7f93230caa",
".git/objects/5e/3ad135d63ec016c2735731ba33265e4db996cf": "3393b698e3557198178714d24b8065a6",
".git/objects/5e/61731e0467894c6ed67f1ab3550af0d34441b6": "7ea059fb45b3f3d0d391cbfcd7f2b002",
".git/objects/5f/0111ecd4d724b2a3260bbd8d5e3e9b0e6887b7": "da1d73a46039d9cb9b1d2a09c750a350",
".git/objects/62/c00448d5ac267d886cab87b682d897b82d4131": "9d8286e802da642310f6646225824fdd",
".git/objects/65/78687427a57cccb496cf64ec4f7db864b2e249": "edeca4c51d1a937e4678c21bdd42589a",
".git/objects/67/89d4eaf0d8195cd72a0a92247e85d0d218cc62": "d29f01b1279f6c4d706e41d2ddf28ab1",
".git/objects/72/4f9a900fd4dfa7369816f26d5538ff6f71149a": "d74858fbefbc66c734de405ffebf5ac1",
".git/objects/79/ba7ea0836b93b3f178067bcd0a0945dbc26b3f": "f3e31aec622d6cf63f619aa3a6023103",
".git/objects/7d/2036b3707b8543b8c958fd54f60f47624d4bc0": "5b65116dc3f79e9a1d79943afc79eac5",
".git/objects/84/27a8a32b1151aeaa7bcc8e084809d6008dc9db": "6814d23b75dab88f246a56f0ae96725f",
".git/objects/85/9371a05acb7f9cf5e4c6bb89ff93e123e579f6": "d4fe81dc232131ddf838bec3a2c5f009",
".git/objects/86/3c6a20bda03c05502b54e1ad9c1e600a54e35c": "3e3b958f97d6783a1a54e47610ceeb27",
".git/objects/8d/b9a9020457754b767389c09845e000f8b3977d": "3584f9ab02c2189cfcfdce0a70c9c879",
".git/objects/9c/d4fa1e14431382b229619b61bd5b04607b9e16": "80fdb277844c256716554e2889220e65",
".git/objects/a1/3837a12450aceaa5c8e807c32e781831d67a8f": "bfe4910ea01eb3d69e9520c3b42a0adf",
".git/objects/a8/beffd3ad4fe54d6cabccf83a05477d6a986cd0": "6677888e4a051c7838b5b240c09f0981",
".git/objects/ab/0e98497a51ead7821d1da35a24968ff314e50f": "557c35fe3928eb2af403d1b3926bb9ba",
".git/objects/b7/0dcaf5e2b12da5c3fab3d0197cd8c24632e31f": "73c9c203c0d2022001c1016a14800fef",
".git/objects/ba/baa3b2bec818b382e1a2f4575b9b56041ba062": "0371a817975e1a2f79cd708f38ebbbac",
".git/objects/bb/43fa3e55c1774381baa47deb5c5b167ab3b45e": "99e93c84c515e33acecbd8858e81a299",
".git/objects/c7/6f83d6fe024eae8d025536bff7fa1d047f6397": "c2d784ca0eafc35843878bb3f85b3cc2",
".git/objects/d3/6565c6fc5f1f9d9cb8b143403efcb99de626c9": "d494078d12e2442346d25df4c8a9f501",
".git/objects/dd/97dc698660dc1adb9b206d694271582e342873": "0b6e6beb873dd20d000fd27c1bc49bd4",
".git/objects/dd/9878672007fa71cbca595b5278ac223b10212a": "03fa08e56d777ce7a16da6ec80600974",
".git/objects/de/9df0b7afef5690414861070194dbee58121f08": "4ac8e1a7f8efeeab475248360ffbd921",
".git/objects/e4/97b867cf7ae7d963bbf8021f326ba4728600a5": "8ef22a6dccae7a0a4b91f7022933585e",
".git/objects/e5/951dfb943474a56e611d9923405cd06c2dd28d": "c6fa51103d8db5478e1a43a661f6c68d",
".git/objects/e9/147cd7ae40d5915f5b18ba7b77717431e705f8": "5019e0b0626246f41ae3032e99cbc9c0",
".git/objects/ec/f2d8ef4681e3ea986ca3dd7d2eaa4a241458bb": "c0545419de55b152ae411787da264ccc",
".git/objects/ee/2ad18feb89939577630f34e9261ed371c4cae0": "abc8dcf9b206eb88a8c4940e54c90eb6",
".git/objects/ee/9eeb244176bff4c47a7317ca97ecb6c4c7b40f": "8093b84776b1b5166041ffd92ace1123",
".git/objects/f5/4c826773d797f370417e7f84e9e0e26fdbf4d3": "0fb115bc212e167082a5ddc3cb7902fe",
".git/objects/f9/dd25e1da48eb45dd9ed1530e63ee6a506dc2ef": "a8fc78e8a4aa9a0f9031bfcd4c4f25c9",
".git/refs/heads/master": "58b5c12ce40e596f4b6ba83baa0eadef",
".git/refs/remotes/origin/master": "58b5c12ce40e596f4b6ba83baa0eadef",
"assets/AssetManifest.json": "305eb4ce91d22450970494d3eb8c6199",
"assets/assets/avatar/avatar1.svg": "149d7a04f0052f7c7afa884cc070a019",
"assets/assets/avatar/avatar2.svg": "799be5ef230e7f74bafdcde81e379cf8",
"assets/assets/avatar/avatar3.svg": "c684c4c708caeeed5c2a44929f1c90e6",
"assets/assets/avatar/avatar4.svg": "9a440e1273b939b8346c2f98b68c5f4a",
"assets/assets/avatar/avatar5.svg": "f2358d9394e59f90022e33bc62f6732d",
"assets/assets/avatar/avatar6.svg": "22af6b29e860b6ac3824b3359c235ef7",
"assets/assets/icons/logo_source.png": "bf24c3c641ce72c9d9e59da36b0500b6",
"assets/assets/icons/svg/fb.svg": "24e793a229ec85b983d89d7fe85aaa27",
"assets/assets/icons/svg/galaxySVG.svg": "f4387be9ab58b54363118c076fca1224",
"assets/assets/icons/svg/insta.svg": "c63758a3e0efa3a809fdec3da7594eec",
"assets/assets/icons/svg/telegram.svg": "e03cb7dfa982e3b226adce8f901cbaa5",
"assets/assets/icons/svg/whatMobile.svg": "72fd6f760373732e08dadc7a867adaea",
"assets/assets/images/space.jpg": "b3412884f3eb1d6e39976e06aedadc8a",
"assets/assets/social/discord.svg": "079b54328dff98d298ed072af1789c51",
"assets/assets/social/instagram.svg": "41c80bf02e3341de214853cca48c9121",
"assets/assets/social/telegram.svg": "a57dda48369ed3ae0572492041bac990",
"assets/assets/social/twitter.svg": "6a7e1e5058fc4782258f2045eb6099c7",
"assets/assets/social/youtube.svg": "4ffdd8efd44c5292ad88435f89b8efff",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "4e6447691c9509f7acdbf8a931a85ca1",
"assets/NOTICES": "a7e04c68e8cd2ae00f76f555988a4930",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"favicon.png": "2ea2452e4c2389f2057c496b02ef40d7",
"icons/Icon-192.png": "e8b95c3a4b82a558d1d37a8acc7f362a",
"icons/Icon-512.png": "3c1bd107567e94ee31399f3b1ab8e531",
"index.html": "3357a46ed39e8cb556335686d9d67e5e",
"/": "3357a46ed39e8cb556335686d9d67e5e",
"main.dart.js": "d58a9b7d54272352146531f6c9d61edd",
"manifest.json": "2e985092b997211050d823a205e5fd53",
"version.json": "bdef6d566b5a658434e5df4f59fc6d53"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
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
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
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
