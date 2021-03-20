import { Flex } from "@chakra-ui/react";
import React from "react";
import Footer from "../sections/footer"; // will add this in the part 2
import Header from "../sections/header";

export type MainLayoutProps = {
  children: React.ReactNode;
  [rest: string]: any;
};

export default function MainLayout({ children, ...rest }: MainLayoutProps) {
  return (
    <Flex
      direction="column"
      align="center"
      maxW={{ xl: "800px" }}
      m="0 auto"
      {...rest}
    >
      <Header />
      {children}
      <Footer />
    </Flex>
  );
}
