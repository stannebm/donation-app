import { Box, Heading, Image } from "@chakra-ui/react";
import React from "react";
import MainLayout from "../components/layouts/main_layout";
import OfferingForm from "../components/sections/offering_form";

export default function Home(): JSX.Element {
  return (
    <MainLayout>
      <Box borderRadius="xl" bgColor="#f9f9f9" my={10}>
        <Image
          src="/images/mass-offering.png"
          objectFit="cover"
          borderTopRadius="xl"
        />

        <Heading p={3} as="h2" fontWeight={300}>
          Mass Offering
        </Heading>
        <Box p={3}>Mass intentions will be offered by our priests daily.</Box>

        <Box p={5}>
          <OfferingForm></OfferingForm>
        </Box>
      </Box>
    </MainLayout>
  );
}
