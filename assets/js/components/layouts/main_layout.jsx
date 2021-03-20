import React from "react";
import { Flex } from "@chakra-ui/react";
import Header from "../sections/header";
import Footer from "../sections/footer"; // will add this in the part 2

export default function MainLayout(props) {
  return (
    <Flex
      direction="column"
      align="center"
      maxW={{ xl: "800px" }}
      m="0 auto"
      {...props}
    >
      <Header />
      {props.children}
      <Footer />
    </Flex>
  );
}
