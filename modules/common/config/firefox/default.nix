{ pkgs }:

{
  enable = true;
  package = pkgs.firefox-esr;
  preferences = {
    "browser.requireSigning" = false;
    "browser.urlbar.suggest.bookmark" = true;
    "browser.urlbar.suggest.calculator" = false;
    "browser.urlbar.suggest.engines" = false;
    "browser.urlbar.suggest.history" = false;
    "browser.urlbar.suggest.openpage" = false;
    "browser.urlbar.suggest.quicksuggest" = false;
    "browser.urlbar.suggest.searches" = false;
    "browser.urlbar.suggest.topsites" = false;
    "browser.compactmode.show" = true;
    "browser.toolbars.bookmarks.visibility" = "never";
  };
  policies = {
    CaptivePortal = false;
    DisableFirefoxStudies = true;
    DisablePocket = true;
    DisableTelemetry = true;
    DisableFirefoxAccounts = true;
    DisableFormHistory = true;
    FirefoxHome = {
      Search = false;
      TopSites = false;
      SponsoredTopSites = false;
      Highlights = false;
      Pocket = false;
      SponsoredPocket = false;
      Snippets = false;
      Locked = false;
    };
    Homepage = {
      StartPage = "none";
    };
    OfferToSaveLogins = false;
    SearchSuggestEnabled = false;
    NoDefaultBookmarks = true;
    SanitizeOnShutdown = {
      Cache = false;
      Cookies = false;
      Downloads = true;
      FormData = true;
      History = true;
      Sessions = false;
      SiteSettings = false;
      OfflineApps = false;
      Locked = false;
    };
    UserMessaging = {
      ExtensionRecommendations = false;
      SkipOnboarding = true;
    };
    ExtensionSettings = with builtins;
      let extension = shortId: uuid: {
        name = uuid;
        value = {
          install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
          installation_mode = "normal_installed";
        };
      };
      in listToAttrs [
    (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
    (extension "vimium-ff" "{d7742d87-e61d-4b78-b8a1-b469842139fa}")
    (extension "noscript" "{73a6fe31-595d-460b-a920-fcc0f8843232}")
    (extension "darkreader" "addon@darkreader.org")
    (extension "xdebug-helper-for-firefox" "{806cbba4-1bd3-4916-9ddc-e719e9ca0cbf}")
      ];
      # To add additional extensions, find it on addons.mozilla.org, find
      # the short ID in the url (like https://addons.mozilla.org/en-US/firefox/addon/!SHORT_ID!/)
      # Then, download the XPI by filling it in to the install_url template, unzip it,
      # run `jq .browser_specific_settings.gecko.id manifest.json` or
      # `jq .applications.gecko.id manifest.json` to get the UUID

    SearchEngines = {
      Default = "DuckDuckGo";
      Remove = [
        "Google"
        "Amazon.nl"
        "Amazon.co.uk"
        "Bing"
        "eBay"
        "Wikipedia (en)"
      ];
    };
  };
}

