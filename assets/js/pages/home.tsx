import React from "react";
import MainLayout from "../components/layouts/main_layout";
import { Box, Image } from "@chakra-ui/react";

export default function Home(): JSX.Element {
  return (
    <MainLayout>
      <Box>
        <Image
          src="/images/mass-offering.png"
          objectFit="cover"
          borderRadius="2xl"
          borderTopRightRadius="2xl"
        />
        <Box p={5} my={3} bgColor="gray.100">
          Mass intentions will be offered by our priests daily.
        </Box>
      </Box>
    </MainLayout>
  );
}
