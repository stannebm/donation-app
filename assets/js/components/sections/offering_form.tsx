import { Button, Divider, HStack, Stack } from "@chakra-ui/react";
import React from "react";
import { useFieldArray, useForm } from "react-hook-form";
import FormInput from "../elements/form_input";
import FormSelect from "../elements/form_select";
import type { MainForm } from "./offering_form.types";

export default function OfferingForm() {
  const {
    register,
    handleSubmit,
    errors,
    formState,
    control,
  } = useForm<MainForm>({
    defaultValues: {
      requests: [{ typeOfMass: "Special Intention" }],
    },
  });

  const onSubmit = (data: MainForm) => {
    console.log(data);
  };

  const { fields, append, remove } = useFieldArray({
    control,
    name: "requests",
  });

  return (
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
      {fields.map((item, index) => {
        return (
          <Stack mb={3} key={item.id}>
            <FormSelect
              name="typeOfMass"
              label="Mass Offering/Intention"
              options={["Special Intention", "Thanksgiving", "Departed Soul"]}
              errors={errors}
              ref={register({ required: true })}
              defaultValue={item.typeOfMass}
            />
          </Stack>
        );
      })}
      <Button
        mt={4}
        colorScheme="teal"
        isLoading={formState.isSubmitting}
        type="submit"
      >
        Submit
      </Button>
    </form>
  );
}
