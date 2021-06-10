import { MinusIcon, PlusSquareIcon } from "@chakra-ui/icons";
import { Box, Button, HStack, Text, VStack } from "@chakra-ui/react";
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
      offerings: [{ typeOfMass: undefined }],
    },
  });

  const onSubmit = (data: MandatoryForm) => {
    console.log("SUBMIT:", data);
    console.log(JSON.stringify(data))
  };

  const { fields, append, remove } = useFieldArray({
    control,
    name: "offerings",
  });

  const offerings = watch("offerings");
  /* const totalMasses = offerings.reduce(
*   (acc, curr) => acc + curr.numberOfMass,
*   0,
* ); */
  // FIXME use real data
  const totalMasses = 1;
  console.log("errors", errors);

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <HStack mb={3} align="flex-start">
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
          label="Offer by Whom"
          errors={errors}
          {...register("fromWhom", { required: true })}
        />
        <FormSelect
          label="Mass Language"
          options={["English", "Mandarin", "Tamil", "Bahasa"]}
          errors={errors}
          {...register("massLanguage", { required: true })}
        />
      </HStack>
      {fields.map((item, index) => {
        return (
          <>
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
              </HStack>
              <VStack>
                {offerings[index].typeOfMass === "Special Intention" && (
                  <>
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
                      errorPath={R.path(["offerings", index, "intention"])}
                      defaultValue={item.intention}
                      {...register(`offerings.${index}.intention` as const, {
                        required: true,
                      })}
                    />
                  </>
                )}

                {/*
                    FIXME multiple dates
                    <FormInput
                  label="Specific Date(s)"
                  errors={errors}
                  errorPath={R.path(["offerings", index, "specificDates"])}
                  {...register(`offerings.${index}.specificDates` as const)}
                /> */}
              </VStack>
            </Box>
            {index >= 1 && (
              <Box my={5}>
                <Button
                  size="sm"
                  colorScheme="red"
                  fontWeight={400}
                  type="button"
                  variant="outline"
                  leftIcon={<MinusIcon />}
                  onClick={() => remove(index)}
                >
                  Remove Mass Offering
                </Button>
              </Box>
            )}
          </>
        );
      })}

      <Box my={3}>
        <Button
          size="sm"
          fontWeight={400}
          colorScheme="teal"
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
      </Box>


      <Box mb={5}>
        <Text color="gray.500" fontWeight={500} align="left" mb={2}>
          Love offering : RM10 per Mass
        </Text>
        <Text color="gray.600" fontWeight={800} align="left" mb={-1}>
          Total:
        </Text>
        <Text fontSize="2xl" fontWeight={800} as="h3" color="gray.600">
          {`RM ${totalMasses ? totalMasses * 10 : 0}`}
        </Text>
      </Box>

      <HStack>
        <Button colorScheme="teal" isLoading={isSubmitting} type="submit">
          Transfer
        </Button>
      </HStack>
    </form>
  );
}
