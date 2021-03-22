import { Box } from "@chakra-ui/react";
import React from "react";
import Footer from "../sections/footer"; // will add this in the part 2
import Header from "../sections/header";

export type MainLayoutProps = {
  children: React.ReactNode;
  [rest: string]: any;
};

export default function MainLayout({ children, ...rest }: MainLayoutProps) {
  return (
    <Box bgColor="orange.50">
      <Box maxW={{ xl: "620px" }} h={"100vh"} m="0 auto" py={10} {...rest}>
        <Header />
        <Box w="100%">{children}</Box>
        <Footer />
      </Box>
    </Box>
  );
}
