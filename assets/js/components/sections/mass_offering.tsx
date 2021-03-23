import { PlusSquareIcon } from "@chakra-ui/icons";
import { Box, Button, Divider, HStack, VStack } from "@chakra-ui/react";
import * as R from "ramda";
import React from "react";
import { useFieldArray, useForm } from "react-hook-form";
import FormInput from "../elements/form_input";
import FormSelect from "../elements/form_select";
import type { MandatoryForm } from "./mass_offering.types";

export default function MassOffering() {
  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
    control,
    watch,
  } = useForm<MandatoryForm>({
    defaultValues: {
      offerings: [{ typeOfMass: "Special Intention" }],
    },
  });

  const onSubmit = (data: MandatoryForm) => {
    console.log("SUBMIT:", data);
  };

  const { fields, append, remove } = useFieldArray({
    control,
    name: "offerings",
  });

  const offerings = watch("offerings");
  console.log("errors", errors);

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <HStack mb={3} align="flex-start">
        <FormInput
          label="Name"
          errors={errors}
          {...register("contactName", { required: true })}
        />
        <FormInput
          label="Contact H/P"
          errors={errors}
          {...register("contactNumber", { required: true })}
        />
        <FormInput
          label="Email"
          errors={errors}
          {...register("emailAddress", {
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
          label="From Whom"
          errors={errors}
          {...register("fromWhom", { required: true })}
        />
        <FormSelect
          label="Mass Language"
          options={["English", "Mandarin", "Tamil"]}
          errors={errors}
          {...register("massLanguage", { required: true })}
        />
      </HStack>
      {fields.map((item, index) => {
        return (
          <>
            <Divider py={2} my={3} />
            <Box mb={5}>
              <HStack mb={3} key={item.id}>
                <FormSelect
                  label="Mass Offering/Intention"
                  options={[
                    "Special Intention",
                    "Thanksgiving",
                    "Departed Soul",
                  ]}
                  errors={errors}
                  errorPath={R.path(["offerings", index, "typeOfMass"])}
                  defaultValue={item.typeOfMass}
                  {...register(`offerings.${index}.typeOfMass` as const, {
                    required: true,
                  })}
                />
                <FormInput
                  label="Number of Mass"
                  errors={errors}
                  errorPath={R.path(["offerings", index, "numberOfMass"])}
                  {...register(`offerings.${index}.numberOfMass` as const, {
                    required: true,
                    valueAsNumber: true,
                    min: {
                      value: 1,
                      message: "At least 1 mass",
                    },
                  })}
                  type="number"
                  // defaultValue={item.numberOfMass}
                />
              </HStack>
              <VStack>
                <FormInput
                  label="Specific Date(s)"
                  errors={errors}
                  errorPath={R.path(["offerings", index, "specificDates"])}
                  {...register(`offerings.${index}.specificDates` as const)}
                />
                {offerings[index].typeOfMass === "Special Intention" && (
                  <>
                    <FormInput
                      label="To Whom (eg. Saint/Church)"
                      errors={errors}
                      errorPath={R.path(["offerings", index, "toWhom"])}
                      defaultValue={item.toWhom}
                      {...register(`offerings.${index}.toWhom` as const, {
                        required: true,
                      })}
                    />
                    <FormInput
                      label="Intention"
                      errors={errors}
                      errorPath={R.path(["offerings", index, "intention"])}
                      defaultValue={item.intention}
                      {...register(`offerings.${index}.intention` as const, {
                        required: true,
                      })}
                    />
                  </>
                )}
                {offerings[index].typeOfMass === "Thanksgiving" && (
                  <>
                    <FormInput
                      label="To Whom (eg. Saint/Church)"
                      errors={errors}
                      errorPath={R.path(["offerings", index, "toWhom"])}
                      defaultValue={item.toWhom}
                      {...register(`offerings.${index}.toWhom` as const, {
                        required: true,
                      })}
                    />
                    <FormInput
                      label="Intention"
                      errors={errors}
                      errorPath={R.path(["offerings", index, "intention"])}
                      defaultValue={item.intention}
                      {...register(`offerings.${index}.intention` as const, {
                        required: true,
                      })}
                    />
                  </>
                )}
                {offerings[index].typeOfMass === "Departed Soul" && (
                  <>
                    <FormInput
                      label="Name of Departed Soul"
                      errors={errors}
                      errorPath={R.path(["offerings", index, "toWhom"])}
                      defaultValue={item.toWhom}
                      {...register(`offerings.${index}.toWhom` as const, {
                        required: true,
                      })}
                    />
                    <FormInput
                      d="none"
                      label="Intention"
                      errors={errors}
                      errorPath={R.path(["offerings", index, "intention"])}
                      defaultValue={item.intention}
                      {...register(`offerings.${index}.intention` as const, {
                        required: false,
                      })}
                    />
                  </>
                )}
              </VStack>
            </Box>
          </>
        );
      })}
      <HStack>
        <Button colorScheme="teal" isLoading={isSubmitting} type="submit">
          Submit
        </Button>
        <Button
          fontWeight={400}
          type="button"
          variant="outline"
          leftIcon={<PlusSquareIcon />}
          onClick={() => {
            append({
              typeOfMass: "Special Intention",
            });
          }}
        >
          More Offerings
        </Button>
      </HStack>
    </form>
  );
}
