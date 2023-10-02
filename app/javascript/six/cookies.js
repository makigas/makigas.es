import * as Klaro from "klaro/dist/klaro-no-css";
import "klaro/dist/klaro.css";
import "klaro/dist/translations";

const config = {
  cookieExpiresAfterDays: 180,
  default: false,
  lang: "es",
  languages: ["es", "en"],
  translations: {
    es: {
      purposes: {
        video: {
          title: "Servicios de vídeo",
        },
      },
      contextualConsent: {
        description: "¿Cargar el contenido externo? {title}",
        acceptOnce: "Sí por esta vez",
        acceptAlways: "Sí, siempre",
      },
    },
    en: {
      purposes: {
        video: {
          title: "Video services",
        },
      },
      contextualConsent: {
        description: "Load the external content? {title}",
        acceptOnce: "Allow this time",
        acceptAlways: "Always allow",
      },
    },
  },
  styling: {
    // Klaro's variable name picking is not very semantic...
    dark1: "#8eff92",
    light1: "#333",
    green1: "#4d6699",
    "font-size": "16px",
  },
  services: [
    {
      name: "youtube-embed",
      purposes: ["video"],
      consentualContextOnly: true,
      default: true,
      callback(consent) {
        if (consent && window.startYouTubePlayer) {
          window.startYouTubePlayer();
        }
      },
      translations: {
        es: {
          title: "Reproductor de YouTube",
          description: "Incrusta el reproductor de YouTube directamente en este sitio web",
        },
        en: {
          title: "YouTube Player",
          description: "Embeds the YouTube player directly into this website",
        },
      },
    },
  ],
};

window.klaroConfig = config;
window.klaro = Klaro;

document.getElementById("change-klaro-settings").addEventListener("click", () => {
  Klaro.show();
});

Klaro.setup(config);
