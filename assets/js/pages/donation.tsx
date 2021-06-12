import { Box, Text, Image } from "@chakra-ui/react";
import React from "react";
import MainLayout from "../components/layouts/main_layout";
import Donation from "../components/sections/donation";

export default function DonationPage(): JSX.Element {
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
          <Text fontSize="lg" fontWeight={600} color="gray.700">
            Love  Offering &amp; Donation
          </Text>
          <Text fontSize="md" color="gray.600">
            Thank you for your kind support and generous contribution in making the world a better place.
          </Text>
        </Box>

        <Box p={5}>
          <Donation></Donation>
        </Box>
      </Box>
    </MainLayout>
  );
}
