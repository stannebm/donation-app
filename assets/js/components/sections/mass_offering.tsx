import { Button, Divider, HStack, Stack } from "@chakra-ui/react";
import React from "react";
import { useFieldArray, useForm } from "react-hook-form";
import FormInput from "../elements/form_input";
import FormSelect from "../elements/form_select";
import type { MandatoryForm, OfferingForm } from "./mass_offering.types";
import * as R from "ramda";

export default function MassOffering() {
  const {
    register,
    handleSubmit,
    errors,
    formState,
    control,
    watch,
  } = useForm<MandatoryForm>({
    defaultValues: {
      offerings: [{ typeOfMass: "Special Intention" }],
    },
  });

  const onSubmit = (data: MandatoryForm) => {
    console.log(data);
  };

  const { fields, append, remove } = useFieldArray<OfferingForm>({
    control,
    name: "offerings",
  });

  const offerings = watch("offerings");
  console.log("offerings", offerings);

  console.log("errors", errors);

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
              name={`offerings[${index}].typeOfMass`}
              label="Mass Offering/Intention"
              options={["Special Intention", "Thanksgiving", "Departed Soul"]}
              errors={errors}
              errorPath={R.path(["offerings", index, "typeOfMass"])}
              ref={register({ required: true })}
              defaultValue={item.typeOfMass}
            />
            <FormInput
              name={`offerings[${index}].numberOfMass`}
              label="Number of Mass"
              errors={errors}
              errorPath={R.path(["offerings", index, "numberOfMass"])}
              ref={register({
                required: true,
                valueAsNumber: true,
                min: {
                  value: 1,
                  message: "Please enter at least 1",
                },
              })}
              type="number"
              defaultValue={item.numberOfMass}
            ></FormInput>
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
