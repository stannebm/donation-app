import {
  Box,
  Button,
  Divider,
  FormControl,
  FormErrorMessage,
  FormLabel,
  Heading,
  HStack,
  Image,
  Input,
  Stack,
} from "@chakra-ui/react";
import React from "react";
import { useForm } from "react-hook-form";
import FormInput from "../components/elements/form_input";
import FormSelect from "../components/elements/form_select";
import MainLayout from "../components/layouts/main_layout";

export type FormData = {
  contactName: string;
  contactNumber: string;
  emailAddress: string;
  fromWhom: string;
  massLanguage: string;
  typeOfMass: string;
};

export default function Home(): JSX.Element {
  const {
    register,
    handleSubmit,
    watch,
    errors,
    formState,
  } = useForm<FormData>();

  const watchTypeOfMass = watch("typeOfMass");

  const onSubmit = (data: FormData) => {
    console.log(data);
  };

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
          <form onSubmit={handleSubmit(onSubmit)}>
            <HStack mb={3} align="flex-start">
              <FormInput
                name="contactName"
                label="Name"
                errors={errors}
                ref={register({ required: true })}
              />
              <FormInput
                name="contactNumber"
                label="Contact H/P"
                errors={errors}
                ref={register({ required: true })}
              />
              <FormInput
                name="emailAddress"
                label="Email"
                errors={errors}
                ref={register({
                  required: true,
                  pattern: {
                    value: /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i,
                    message: "Invalid email address",
                  },
                })}
              />
            </HStack>
            <HStack mb={3} align="flex-start">
              <FormInput
                name="fromWhom"
                label="From Whom"
                errors={errors}
                ref={register({ required: true })}
              />
              <FormSelect
                name="massLanguage"
                label="Mass Language"
                options={["English", "Mandarin", "Tamil"]}
                errors={errors}
                ref={register({ required: true })}
              />
            </HStack>
            <Divider py={2} my={3} />
            <Stack mb={3}>
              <FormSelect
                name="typeOfMass"
                label="Mass Offering/Intention"
                options={["Thanksgiving", "Special Intention", "Departed Soul"]}
                errors={errors}
                ref={register({ required: true })}
              />
            </Stack>
            <Button
              mt={4}
              colorScheme="teal"
              isLoading={formState.isSubmitting}
              type="submit"
            >
              Submit
            </Button>
          </form>
        </Box>
      </Box>
    </MainLayout>
  );
}
