import { Box, SimpleGrid } from "@chakra-ui/react";
import React from "react";


export default function Home() {
    return <>
        <h1>this is home</h1>
        <SimpleGrid columns={2} spacing={10}>
            <Box bg="tomato" height="80px"></Box>
            <Box bg="tomato" height="80px"></Box>
            <Box bg="tomato" height="80px"></Box>
            <Box bg="tomato" height="80px"></Box>
            <Box bg="tomato" height="80px"></Box>
        </SimpleGrid>
    </>
}
