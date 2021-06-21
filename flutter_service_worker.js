'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
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
"index.html": "4feab60f66ec6a6723ba10a1b127adf9",
"/": "4feab60f66ec6a6723ba10a1b127adf9",
"main.dart.js": "a524d08f5c592acd199ea619841fd1f3",
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
