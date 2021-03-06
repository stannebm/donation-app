import { Box, Text, Image } from "@chakra-ui/react";
import React from "react";
import MainLayout from "../components/layouts/main_layout";
import MassOffering from "../components/forms/mass_offering";

export default function MassOfferingPage(): JSX.Element {
  return (
    <MainLayout>
      <Box borderRadius="xl" bgColor="#f9f9f9" my={10}>
        <Image
          src="/images/mass-offering.png"
          objectFit="cover"
          borderTopRadius="xl"
        />

        {/* <Heading p={3} as="h2" fontWeight={300}>
          Mass Offering
        </Heading> */}
        <Box p={3}>
          <Text fontSize="md" color="gray.600">
            Mass intentions will be offered by our priests daily.
          </Text>
        </Box>

        <Box p={5}>
          <MassOffering></MassOffering>
        </Box>
      </Box>
    </MainLayout>
  );
}
