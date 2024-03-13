import * as Klaro from "klaro/dist/klaro-no-css";
import "klaro/dist/klaro.css";
import "klaro/dist/translations";

function iframeRenderConsentDialog() {
  const consent = document.querySelector(".ytiframe .consent");
  if (consent) {
    consent.classList.add("consent--visible");

    document.getElementById("iframe-allow-now").addEventListener("click", () => {
      const manager = window.klaro.getManager();
      manager.updateConsent("youtube-embed", true);
      manager.applyConsents(false, true, "youtube-embed");
      manager.updateConsent("youtube-embed", false);
    });

    document.getElementById("iframe-allow-always").addEventListener("click", () => {
      const manager = window.klaro.getManager();
      manager.updateConsent("youtube-embed", true);
      if (manager.confirmed) {
        manager.saveConsents("contextual-accept");
      }
      manager.applyConsents(false, true, "youtube-embed");
    });
  }
}

function iframeHideConsentDialog() {
  const consent = document.querySelector(".ytiframe .consent");
  if (consent) {
    consent.classList.remove("consent--visible");
  }
}

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
      consentModal: {
        title: "Servicios que usan cookies",
        description:
          "Aquí puedes ajustar tu configuración para permitir ciertos componentes de la web que pueden depositar cookies en tu navegador.",
      },
      consentNotice: {
        description:
          "Este sitio web utiliza cookies para reproducir los vídeos en las páginas de artículo. Puedes aceptarlas o rechazarlas. Si no las aceptas no funcionarán los vídeos, aunque a cambio puedes rechazarlas gratis.",
        learnMore: "Déjame ver",
      },
      ok: "Aceptar todo",
      decline: "Rechazar todo",
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
    "notice-left": "20px",
    "notice-max-width": "600px",
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
          iframeHideConsentDialog();
        } else if (!consent) {
          iframeRenderConsentDialog();
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
