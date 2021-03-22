import { extendTheme } from "@chakra-ui/react";

const theme = extendTheme({
  fonts: {
    heading: "Roboto",
    body: "Montserrat",
  },
  layerStyles: {
    "inset-0": {
      position: "absolute",
      top: 0,
      bottom: 0,
      left: 0,
      right: 0,
    },
    "top-0": {
      position: "absolute",
      top: 0,
      left: 0,
      right: 0,
    },
    "bottom-0": {
      position: "absolute",
      bottom: 0,
      left: 0,
      right: 0,
    },
    "top-right": {
      position: "absolute",
      top: 0,
      right: 0,
    },
  },
  styles: {
    global: {
      "html, body": {},
    },
  },
});

export default theme;
