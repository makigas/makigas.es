import "normalize.css";
import "@fontsource/montserrat/400.css";
import "@fontsource/montserrat/700.css";

import * as klaro from "klaro";
const config = {
  lang: "es",
  translations: {
    en: {
      googleAnalytics: {
        title: "Google Anayltics",
        description: "To understand which pages are most visited by the users",
      },
      purposes: {
        analytics: "Analytics",
      },
    },
    es: {
      googleAnalytics: {
        title: "Google Analytics",
        description: "Para comprender las páginas que más visitáis",
      },
      purposes: {
        analytics: "Analítica",
      },
    },
  },
  services: [
    {
      name: "googleAnalytics",
      purposes: ["analytics"],
    },
  ],
};
window.klaro = klaro;
window.klaroConfig = config;
klaro.setup(config);

import "../six/components/navbar";
import "../six/components/videoexplorer";

import "../six/layout/colors.scss";
import "../six/layout/responsive.scss";
import "../six/layout/typography.scss";
import "../six/layout/base.scss";
import "../six/front.scss";
import "../six/components/button.scss";
import "../six/components/discordcta.scss";
import "../six/components/explorer.scss";
import "../six/components/footer.scss";
import "../six/components/jumbo.scss";
import "../six/components/meta.scss";
import "../six/components/navbar.scss";
import "../six/components/plhead.scss";
import "../six/components/plcard.scss";
import "../six/components/videocard.scss";
import "../six/components/videolist.scss";
import "../six/components/search.scss";
import "../six/components/topcard.scss";
import "../six/components/topicthumb.scss";
import "../six/components/videoinfo.scss";
import "../six/components/videoexplorer.scss";
import "../six/components/ytiframe.scss";
