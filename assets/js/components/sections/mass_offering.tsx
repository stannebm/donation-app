import { Box, Button, Divider, HStack, VStack } from "@chakra-ui/react";
import * as R from "ramda";
import React from "react";
import { useFieldArray, useForm } from "react-hook-form";
import FormInput from "../elements/form_input";
import FormSelect from "../elements/form_select";
import type {
  DepartedSoulForm,
  MandatoryForm,
  OfferingForm,
  SpecialIntentionForm,
  ThanksgivingForm,
} from "./mass_offering.types";

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
          <Box>
            <HStack mb={3} key={item.id}>
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
              />
            </HStack>
            <VStack>
              <FormInput
                name={`offerings[${index}].specificDates`}
                label="Specific Date(s)"
                errors={errors}
                errorPath={R.path(["offerings", index, "specificDates"])}
                ref={register()}
                defaultValue={item.specificDates}
              />
              {offerings[index].typeOfMass === "Special Intention" && (
                <>
                  <FormInput
                    name={`offerings[${index}].toWhom`}
                    label="To Whom (eg. Saint/Church)"
                    errors={errors}
                    errorPath={R.path(["offerings", index, "toWhom"])}
                    ref={register({
                      required: true,
                    })}
                    defaultValue={(item as SpecialIntentionForm).toWhom}
                  />
                  <FormInput
                    name={`offerings[${index}].intention`}
                    label="Intention"
                    errors={errors}
                    errorPath={R.path(["offerings", index, "intention"])}
                    ref={register({
                      required: true,
                    })}
                    defaultValue={(item as SpecialIntentionForm).intention}
                  />
                </>
              )}
              {offerings[index].typeOfMass === "Thanksgiving" && (
                <>
                  <FormInput
                    name={`offerings[${index}].toWhom`}
                    label="To Whom (eg. Saint/Church)"
                    errors={errors}
                    errorPath={R.path(["offerings", index, "toWhom"])}
                    ref={register({
                      required: true,
                    })}
                    defaultValue={(item as ThanksgivingForm).toWhom}
                  />
                  <FormInput
                    name={`offerings[${index}].intention`}
                    label="Intention"
                    errors={errors}
                    errorPath={R.path(["offerings", index, "intention"])}
                    ref={register({
                      required: true,
                    })}
                    defaultValue={(item as ThanksgivingForm).intention}
                  />
                </>
              )}
              {offerings[index].typeOfMass === "Departed Soul" && (
                <>
                  <FormInput
                    name={`offerings[${index}].toWhom`}
                    label="Name of Departed Soul"
                    errors={errors}
                    errorPath={R.path(["offerings", index, "toWhom"])}
                    ref={register({
                      required: true,
                    })}
                    defaultValue={(item as DepartedSoulForm).toWhom}
                  />
                </>
              )}
            </VStack>
          </Box>
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
