import { ChakraProvider } from "@chakra-ui/react";
import React from "react";
import Donation from "./pages/donation";
import MassOffering from "./pages/mass-offering";
// import Login from "./pages/login";
import theme from "./theme";

function Routes() {
  return (
    <>
      {window.location.pathname.startsWith("/mass-offering") && (
        <MassOffering />
      )}
      {window.location.pathname.startsWith("/donation") && <Donation />}
    </>
  );
}

function App() {
  return (
    <ChakraProvider theme={theme}>
      <Routes />
    </ChakraProvider>
  );
}

export default App;
