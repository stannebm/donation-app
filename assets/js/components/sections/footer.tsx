import React from "react";
import { Text } from "@chakra-ui/react";

export default function Footer(): JSX.Element {
  return (
    <Text fontSize="sm" pos="absolute" bottom={0} m={5} color="gray.100">
      &copy; Copyright 2020-2021 minorbasilicastannebm.com. All Rights Reserved.
    </Text>
  );
}
